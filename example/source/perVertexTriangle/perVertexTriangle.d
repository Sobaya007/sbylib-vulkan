import std;
import erupted;
import erupted.vulkan_lib_loader;
import sbylib.wrapper.vulkan;
import sbylib.wrapper.vulkan.util : compileShader;
import sbylib.wrapper.glfw : GLFW, Window, WindowBuilder, ClientAPI;

void entryPoint() {
    /*
       GLFW初期化
     */
    GLFW.initialize();
    scope (exit)
        GLFW.terminate();


    /*
       Window作成
     */
    Window window;
    with (WindowBuilder()) {
        width = 800;
        height = 600;
        title = "title";
        clientAPI = ClientAPI.NoAPI;
        resizable = false;
        window = buildWindow();
    }
    scope (exit)
        window.destroy();


    /*
       GLFWのVulkanサポートチェック
     */
    assert(GLFW.hasVulkanSupport());


    /*
       VulkanのGlobal Functionを読み込む
     */
    const globalFunctionLoaded = loadGlobalLevelFunctions();
    assert(globalFunctionLoaded);


    /*
       Intanceの作成

       Validation Layerを有効化する場合はここで設定する。
       (ただし利用可能かどうかチェックする)

       GLFWが要求する拡張機能も有効化する。

     */
    Instance.CreateInfo instanceCreateInfo = {
        applicationInfo: {
            applicationName: "Vulkan Test",
            applicationVersion: VK_MAKE_VERSION(1,0,0),
            engineName: "No Engine",
            engineVersion: VK_MAKE_VERSION(1,0,0),
            apiVersion : VK_API_VERSION_1_0
        },
        enabledLayerNames: [
            "VK_LAYER_LUNARG_core_validation",
            "VK_LAYER_LUNARG_standard_validation",
            "VK_LAYER_LUNARG_parameter_validation",
            "VK_LAYER_KHRONOS_validation",
        ],
        enabledExtensionNames: GLFW.getRequiredInstanceExtensions()
    };

    enforce(instanceCreateInfo.enabledLayerNames.all!(n =>
        LayerProperties.getAvailableInstanceLayerProperties().canFind!(l => l.layerName == n)));

    auto instance = new Instance(instanceCreateInfo);
    scope (exit)
        instance.destroy();


    /*
       Surface作成

       SurfaceとはVulkanのAPIとWindow Systemをつなぐものらしい
     */
    auto surface = window.createSurface(instance);
    scope (exit)
        surface.destroy();


    /*
       GPUの選択

       GPUはPhysical DeviceとVulkan内では呼ばれている。
       利用可能なGPUの中で、Surface機能をサポートしているものを採用。
     */
    auto physDevices = instance.enumeratePhysicalDevices();
    const gpuIndex = physDevices.countUntil!(p => p.getSurfaceSupport(surface));
    enforce(gpuIndex != -1, "There are no GPUs with Surface support.");
    auto gpu = physDevices[gpuIndex];


    /*
       Queue Familyの選択

       Vulkanの命令の多くは
        1. Command Bufferに命令を記録
        2. Command BufferをQueueに追加
       というプロセスをたどる。
       Command Bufferに記録する命令には"Supported Queue Type"とかいう属性が1つ定められており、
       Queueに突っ込む際はその属性をサポートしているQueueに突っ込まなければならない。
       Queue Familyというのは要はこのQueueの種類のことであり、今回はGraphics属性をサポートしているQueueを採用する。
     */
    const queueFamilyProperties = gpu.getQueueFamilyProperties();
    auto graphicsQueueFamilyIndex = cast(uint)queueFamilyProperties
        .countUntil!((const QueueFamilyProperties prop) =>
                prop.supports(QueueFamilyProperties.Flags.Graphics));
    enforce(graphicsQueueFamilyIndex != -1, "There are no queue family with Graphics support.");


    /*
       Deviceの作成

       選択した"物理的な"Deviceを基に"論理的な"Deviceを作成する
       DeviceにもInstanceと同様、LayerとExtensionが付けられる。
       今回はSwapchainのExtensionのみ有効化する。
       ついでに先程選んだQueue FamilyでQueueを1つ作っておく。
     */
    Device.DeviceCreateInfo deviceCreateInfo = {
        queueCreateInfos: [{
            queuePriorities: [0.0f],
            queueFamilyIndex: graphicsQueueFamilyIndex,
        }],
        enabledExtensionNames: ["VK_KHR_swapchain"]
    };
    auto device = new Device(gpu, deviceCreateInfo);
    scope (exit)
        device.destroy();

    auto queue = device.getQueue(graphicsQueueFamilyIndex, 0);


    /*
       Command Poolの作成

       Command PoolとはCommand Bufferを確保する元の領域らしい。
       flagsにTransient, ResetCommandBuffer, Protectedを0個以上選んで入れられる。

       Transient:
            このCommand Poolから確保されるCommand Bufferは短命(比較的すぐResetされるか解放される)。
            メモリ確保の戦略に使われるんじゃね？とのこと。
       ResetCommandBuffer:
            このCommand Poolから確保されるCommand Bufferは個別にReset可能になる。
            ResetはvkResetCommandBufferかvkBeginCommandBufferでできる。
            逆にこのフラグ立てずに上記命令を呼び出してはいけない(vkResetCommandPoolなる命令でまとめてやる)。
        Protected:
            このCommand Poolから確保されるCommand Bufferは(Memory) Protectedになる。
            Protectedになると、よくないメモリアクセスでちゃんと怒ってくられるようになるっぽい。

     */
    CommandPool.CreateInfo commandPoolCreateInfo = {
        flags: CommandPool.CreateInfo.Flags.ResetCommandBuffer
             | CommandPool.CreateInfo.Flags.Protected,
        queueFamilyIndex: graphicsQueueFamilyIndex
    };
    auto commandPool = new CommandPool(device, commandPoolCreateInfo);
    scope (exit)
        commandPool.destroy();


    /*
       Swapchainの作成

       Swapchainとはスクリーンに表示されるImageのQueueみたいなもん。
       Swapchainを作るとき、内部に含まれるImageも併せて作成される。
       presentModeは表示(同期)の方法。

       Immediate:
            垂直同期すらせず、来た瞬間表示
       Mailbox:
            垂直同期をする。
            内部的に用意された容量1のQueueを用い、画像が来たら溜め込み、垂直同期の瞬間が来たら取り出して表示する。
            画像が既にあるのに来ちゃったら古いほうを破棄。
       FIFO:
            Mailboxの容量いっぱい版。
       FIFORelaxed:
            FIFO + 「垂直同期のタイミングなのに次の画像がまだ来ていなかった場合、次のが来次第すぐ表示」。
       SharedDemandRefresh:
            表示エンジンとアプリケーションの双方からの並列なImageへのアクセスを許可する。
            アプリケーションはアクセスしているImageの更新が必要なときは必ず更新リクエストを投げなければならない。
            表示タイミングについてはいつかわからない。
       SharedContinuousRefresh
            表示エンジンとアプリケーションの双方からの並列なImageへのアクセスを許可する。
            Imageの更新は通常のサイクルと同様に周期的に起きる。
            アプリケーションは一番最初だけ更新リクエストを投げなければならない。
     */
    const surfaceCapabilities = gpu.getSurfaceCapabilities(surface);

    const surfaceFormats = gpu.getSurfaceFormats(surface);
    const surfaceFormat = surfaceFormats.find!(f => f.format == VK_FORMAT_B8G8R8A8_UNORM).front;

    Swapchain.CreateInfo swapchainCreateInfo = {
        surface: surface,
        minImageCount: surfaceCapabilities.minImageCount,
        imageFormat: surfaceFormat.format,
        imageColorSpace: surfaceFormat.colorSpace,
        imageExtent: surfaceCapabilities.currentExtent,
        imageArrayLayers: 1,
        imageUsage: ImageUsage.ColorAttachment,
        imageSharingMode: SharingMode.Exclusive,
        compositeAlpha: CompositeAlpha.Opaque,
        preTransform: SurfaceTransform.Identity,
        presentMode: PresentMode.FIFO,
        clipped: true,
    };
    enforce(surfaceCapabilities.supports(swapchainCreateInfo.imageUsage));
    enforce(surfaceCapabilities.supports(swapchainCreateInfo.compositeAlpha));
    enforce(surfaceCapabilities.supports(swapchainCreateInfo.preTransform));
    enforce(gpu.getSurfacePresentModes(surface).canFind(swapchainCreateInfo.presentMode));

    auto swapchain = new Swapchain(device, swapchainCreateInfo);
    scope (exit)
        swapchain.destroy();

    auto swapchainImages = swapchain.getImages();


    /*
       SwapchainからImageViewを作成

       ImageViewとはその名の通り、Swapchain内のImageに対するView(Slice)である。
     */
    auto swapchainImageViews = swapchainImages.map!((Image image) {
        ImageView.CreateInfo info = {
            image: image,
            viewType: ImageViewType.Type2D,
            format: surfaceFormat.format,
            subresourceRange: {
                aspectMask: ImageAspect.Color,
                baseMipLevel: 0,
                levelCount: 1,
                baseArrayLayer: 0,
                layerCount: 1,
            }
        };
        return new ImageView(device, info);
    }).array;
    scope (exit)
        foreach (imageView; swapchainImageViews)
            imageView.destroy();


    /*
       RenderPassの作成

       RenderPassはFramebufferをどうやって処理するかという設定集。
       設定のみで、具体的な処理は書いてない。

       RenderPassはAttachmentとSubpassとDependencyから成る。

       Attachmentは計算中に現れる資源がどんなもんかという設定。
       ここではAttachmentはSwapchain内に作ったImage。
       loadOp, storeOpは計算の開始/終了時にデータをどう処理するかを書く。
       各資源にはlayoutなる状態が定義されているらしく、開始/終了時のlayoutを決めておく。
       資源の終了時のLayoutは必ずPRESENT_SRCにしておかないと描画(present)できないっぽい。

       Subpassは計算中に資源をどういうふうに使うかの設定。
       「Attachment0番をCOLOR_ATTACH_MENT_OPTIMALレイアウト状態でcolor attachmentとして使う」というSubpassを1つ定義している。

       DependencyはSubpass間の資源の依存性に関する設定。
       ここでは書いていない。(Subpassが1つしかないから依存もクソもない)
     */
    RenderPass.CreateInfo renderPassCreateInfo = {
        attachments: [{
            format: surfaceFormat.format,
            samples: SampleCount.Count1,
            loadOp: AttachmentLoadOp.Clear,
            storeOp: AttachmentStoreOp.Store,
            initialLayout: ImageLayout.Undefined,
            finalLayout: ImageLayout.PresentSrc,
        }],
        subpasses: [{
            pipelineBindPoint: PipelineBindPoint.Graphics,
            colorAttachments: [{
                attachment: 0,
                layout: ImageLayout.ColorAttachmentOptimal
            }]
        }]
    };
    auto renderPass = new RenderPass(device, renderPassCreateInfo);
    scope (exit)
        renderPass.destroy();


    /*
       Framebufferの作成

       いつもの。
     */
    auto framebuffers = swapchainImageViews.map!((imageView) {
        Framebuffer.CreateInfo info = {
            renderPass: renderPass,
            attachments: [imageView],
            width: 800,
            height: 600,
            layers: 1,
        };
        return new Framebuffer(device, info);
    }).array;
    scope (exit)
        foreach (framebuffer; framebuffers)
            framebuffer.destroy();


    /*
       CommandBufferの確保

       さっきつくったCommandPoolからCommandBufferを確保する。
       確保とかいうからサイズとかを指定するかと思ったけど、そうでもないっぽい。
       一気にいっぱい確保できるが、とりあえず1個確保。
     */
    CommandBuffer.AllocateInfo commandbufferAllocInfo = {
        commandPool: commandPool,
        level: CommandBufferLevel.Primary,
        commandBufferCount: 1,
    };
    auto commandBuffer = CommandBuffer.allocate(device, commandbufferAllocInfo)[0];
    scope (exit)
        commandBuffer.destroy();


    /*
       頂点データの作成

       好きにやればいいっぽい。
     */
    struct VertexData {
        float[2] pos;
        float[3] color;
    }

    static VertexData[3] vertices = [
        VertexData([ 0.0f, -0.5f], [1.0f, 0.0f, 0.0f]),
        VertexData([+0.5f, +0.5f], [0.0f, 1.0f, 0.0f]),
        VertexData([-0.5f, +0.5f], [0.0f, 0.0f, 1.0f]),
    ];


    /*
       Bufferの作成

       今回の用途は当然Vertex Buffer。
     */
    Buffer.CreateInfo bufferInfo = {
        usage: BufferUsage.VertexBuffer,
        size: vertices.sizeof,
        sharingMode: SharingMode.Exclusive,
    };
    auto buffer = new Buffer(device, bufferInfo);
    scope (exit)
        buffer.destroy();


    /*
       Device Memory確保

       Vertex Buffer用のメモリ確保。
     */ 
    DeviceMemory.AllocateInfo deviceMemoryAllocInfo = {
        allocationSize: device.getBufferMemoryRequirements(buffer).size,
        memoryTypeIndex: cast(uint)gpu.getMemoryProperties().memoryTypes
            .countUntil!(p => p.supports(MemoryProperties.MemoryType.Flags.HostVisible))
    };
    enforce(deviceMemoryAllocInfo.memoryTypeIndex != -1);
    auto deviceMemory = new DeviceMemory(device, deviceMemoryAllocInfo);
    scope (exit)
        deviceMemory.destroy();


    /*
       Device Memoryへのデータ転送
     */
    auto mappedMemory = deviceMemory.map(0, bufferInfo.size, 0);
    mappedMemory[] = (cast(ubyte[])vertices)[];
    deviceMemory.unmap();


    /*
       Device MemoryとBufferの紐づけ
     */
    deviceMemory.bindBuffer(buffer, 0);


    /*
       Shader Module作成
     */
    compileShader(__FILE_FULL_PATH__.dirName.buildPath("test.vert"));
    compileShader(__FILE_FULL_PATH__.dirName.buildPath("test.frag"));

    ShaderModule.CreateInfo vsShaderCreateInfo = {
        code: cast(ubyte[])read("vert.spv")
    };
    auto vsMod = new ShaderModule(device, vsShaderCreateInfo);
    scope (exit)
        vsMod.destroy();

    ShaderModule.CreateInfo fsShaderCreateInfo = {
        code: cast(ubyte[])read("frag.spv")
    };
    auto fsMod = new ShaderModule(device, fsShaderCreateInfo);
    scope (exit)
        fsMod.destroy();


    /*
       PipelineLayout作成

       Pipelineが使う資源のレイアウトに関する情報らしい。
       今回は虚無。
     */
    PipelineLayout.CreateInfo pipelineLayoutCreateInfo;
    auto pipelineLayout = new PipelineLayout(device, pipelineLayoutCreateInfo);
    scope (exit)
        pipelineLayout.destroy();


    /*
       Pipeline作成

       Pipelineとは、その名の通り描画パイプラインそのもの。
       設定自体は長いが、全部自明。
     */
    Pipeline.CreateInfo pipelineCreateInfo = {
        stages: [{
            stage: ShaderStage.Vertex,
            _module: vsMod,
            pName: "main",
        }, {
            stage: ShaderStage.Fragment,
            _module: fsMod,
            pName: "main",
        }],
        vertexInputState: {
            vertexBindingDescriptions: [{
                binding: 0,
                stride: VertexData.sizeof,
                inputRate: VertexInputRate.Vertex
            }],
            vertexAttributeDescriptions: [{
                location: 0,
                binding: 0,
                format: VK_FORMAT_R32G32_SFLOAT,
                offset: VertexData.pos.offsetof
            },{
                location: 1,
                binding: 0,
                format: VK_FORMAT_R32G32B32_SFLOAT,
                offset: VertexData.color.offsetof
            }]
        },
        inputAssemblyState: {
            topology: PrimitiveTopology.TriangleList,
        },
        viewportState: {
            viewports: [{
                x: 0.0f,
                y: 0.0f,
                width: window.width,
                height: window.height,
                minDepth: 0.0f,
                maxDepth: 1.0f
            }],
            scissors: [{
                offset: {
                    x: 0,
                    y: 0
                },
                extent: {
                    width: window.width,
                    height: window.height
                }
            }]
        },
        rasterizationState: {
            depthClampEnable: false,
            rasterizerDiscardEnable: false,
            polygonMode: PolygonMode.Fill,
            cullMode: CullMode.None,
            frontFace: FrontFace.CounterClockwise,
            depthBiasEnable: false,
            depthBiasConstantFactor: 0.0f,
            depthBiasClamp: 0.0f,
            depthBiasSlopeFactor: 0.0f,
            lineWidth: 1.0f,
        },
        multisampleState: {
            rasterizationSamples: SampleCount.Count1,
            sampleShadingEnable: false,
            alphaToCoverageEnable: false,
            alphaToOneEnable: false,
        },
        colorBlendState: {
            logicOpEnable: false,
            attachments: [{
                blendEnable: false,
                colorWriteMask: ColorComponent.R
                              | ColorComponent.G
                              | ColorComponent.B
                              | ColorComponent.A,
            }]
        },
        layout: pipelineLayout,
        renderPass: renderPass,
        subpass: 0,
    };
    auto pipeline = Pipeline.create(device, [pipelineCreateInfo])[0];
    scope (exit)
        pipeline.destroy();


    /*
       Fenceの作成

       Fenceとは同期用のアイテムで、Vulkanにおける非同期命令はだいたいこのFenceと一緒に投げて、Fenceを使って待つ。
     */
    Fence.CreateInfo fenceCreatInfo;
    auto fence = new Fence(device, fenceCreatInfo);
    scope (exit)
        fence.destroy();
    

    /*
       Image Indexの取得

       Swapchain内のImageの何番を次叩くべきかを得る。
       Fenceと一緒に投げる理由は、返ってくるIndexのImageが解放されているかがわからないためらしい。
       Fenceは使い終わったら必ずResetすること。
     */
    auto currentImageIndex = swapchain.acquireNextImageIndex(ulong.max, null, fence);
    Fence.wait([fence], false, ulong.max);
    Fence.reset([fence]);


    while (window.shouldClose is false) {
        auto framebuffer = framebuffers[currentImageIndex];

        /*
           Command Bufferへの記録

           CommandBufferへCommandを記録するときは必ずbeginしてendする。
           ここではRenderPassの実行を記録している。
           RenderPassの実行は
            1. PipelineのBind (OpenGLでいうusePipeline)
            2. Vertex BufferのBind (OpenGLでいうbindBuffer)
            3. Draw call (OpenGLでいうdrawArrays)
           となっている。
         */
        CommandBuffer.BeginInfo beginInfo;
        commandBuffer.begin(beginInfo);

        CommandBuffer.RenderPassBeginInfo renderPassBeginInfo = {
            renderPass: renderPass,
            framebuffer: framebuffers[currentImageIndex],
            renderArea: { 
                extent: VkExtent2D(window.width, window.height) 
            },
            clearValues: [{
                color: {
                    float32: [0.0f, 0.0f, 0.0f, 1.0f]
                }
            }]
        };
        commandBuffer.cmdBeginRenderPass(renderPassBeginInfo, SubpassContents.Inline);
        commandBuffer.cmdBindPipeline(PipelineBindPoint.Graphics, pipeline);
        commandBuffer.cmdBindVertexBuffers(0, [buffer], [0]);
        commandBuffer.cmdDraw(3, 1, 0, 0);
        commandBuffer.cmdEndRenderPass();
        commandBuffer.end();


        /*
           QueueへのCommand Bufferの投函

           これも完了を待っている。
         */
        Queue.SubmitInfo submitInfo = {
            commandBuffers: [commandBuffer]
        };
        queue.submit([submitInfo], fence);
        Fence.wait([fence], true, ulong.max);
        Fence.reset([fence]);


        /*
           画面への反映
         */
        Queue.PresentInfo presentInfo = {
            swapchains: [swapchain],
            imageIndices: [currentImageIndex]
        };
        queue.present(presentInfo);


        /*
           次の Image Indexの取得
         */
        currentImageIndex = swapchain.acquireNextImageIndex(ulong.max, null, fence);
        Fence.wait([fence], true, ulong.max);
        Fence.reset([fence]);


        /*
           GLFWのEvent Polling
         */
        GLFW.pollEvents();
    }
}
