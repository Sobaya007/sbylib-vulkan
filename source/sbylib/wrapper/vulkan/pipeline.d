module sbylib.wrapper.vulkan.pipeline;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.pipelinelayout;
import sbylib.wrapper.vulkan.renderpass;
import sbylib.wrapper.vulkan.shadermodule;
import sbylib.wrapper.vulkan.util;

class Pipeline {
    static struct ShaderStageCreateInfo {

        @vkProp() {
            immutable VkPipelineShaderStageCreateFlags flags;
            BitFlags!ShaderStage stage;
            ShaderModule _module;
            string pName;
            const(VkSpecializationInfo)* pSpecializationInfo;
        }

        mixin VkTo!(VkPipelineShaderStageCreateInfo);
    }

    static struct VertexInputStateCreateInfo {
        static struct VertexInputBindingDescription {
            @vkProp() {
                uint binding;
                uint stride;
                VertexInputRate inputRate;
            }

            const mixin VkTo!(VkVertexInputBindingDescription);
        }

        @vkProp() {
            immutable VkPipelineVertexInputStateCreateFlags flags;
        }

        @vkProp("pVertexBindingDescriptions", "vertexBindingDescriptionCount") {
            const VertexInputBindingDescription[] vertexBindingDescriptions;
        }

        @vkProp("pVertexAttributeDescriptions", "vertexAttributeDescriptionCount") {
            const VkVertexInputAttributeDescription[] vertexAttributeDescriptions;
        }

        const mixin VkTo!(VkPipelineVertexInputStateCreateInfo);
    }

    static struct InputAssemblyStateCreateInfo {
        @vkProp() {
            VkPipelineInputAssemblyStateCreateFlags flags;
            PrimitiveTopology topology;
            bool primitiveRestartEnable;
        }

        const mixin VkTo!(VkPipelineInputAssemblyStateCreateInfo);
    }

    static struct RasterizationStateCreateInfo {
        @vkProp() {
            VkPipelineRasterizationStateCreateFlags flags;
            bool depthClampEnable;
            bool rasterizerDiscardEnable;
            PolygonMode polygonMode;
            CullMode cullMode;
            FrontFace frontFace;
            bool depthBiasEnable;
            float depthBiasConstantFactor;
            float depthBiasClamp;
            float depthBiasSlopeFactor;
            float lineWidth;
        }

        const mixin VkTo!(VkPipelineRasterizationStateCreateInfo);
    }

    static struct MultisampleStateCreateInfo {
        @vkProp() {
            VkPipelineMultisampleStateCreateFlags flags;
            SampleCount rasterizationSamples;
            bool sampleShadingEnable;
            float minSampleShading;
            const(VkSampleMask)* pSampleMask;
            bool alphaToCoverageEnable;
            bool alphaToOneEnable;
        }

        const mixin VkTo!(VkPipelineMultisampleStateCreateInfo);
    }

    static struct ViewportStateCreateInfo {
        @vkProp() {
            immutable VkPipelineViewportStateCreateFlags flags;
        }

        @vkProp("pViewports", "viewportCount") {
            const VkViewport[] viewports;
        }

        @vkProp("pScissors", "scissorCount") {
            const VkRect2D[] scissors;
        }

        const mixin VkTo!(VkPipelineViewportStateCreateInfo);
    }

    static struct ColorBlendStateCreateInfo {
        static struct AttachmentState {
            @vkProp() {
                bool blendEnable;
                BlendFactor srcColorBlendFactor;
                BlendFactor dstColorBlendFactor;
                BlendOp colorBlendOp;
                BlendFactor srcAlphaBlendFactor;
                BlendFactor dstAlphaBlendFactor;
                BlendOp alphaBlendOp;
                BitFlags!ColorComponent colorWriteMask;
            }

            const mixin VkTo!(VkPipelineColorBlendAttachmentState);
        }

        @vkProp() immutable {
            VkPipelineColorBlendStateCreateFlags flags;
            bool logicOpEnable;
            LogicOp logicOp;
            float[4] blendConstants;
        }

        @vkProp("pAttachments", "attachmentCount") {
            const AttachmentState[] attachments;
        }

        const mixin VkTo!(VkPipelineColorBlendStateCreateInfo);
    }

    static struct DynamicStateCreateInfo {
        @vkProp() immutable {
            VkPipelineDynamicStateCreateFlags flags;
        }

        @vkProp("pDynamicStates", "dynamicStateCount") {
            const VkDynamicState[] dynamicStates;
        }

        const mixin VkTo!(VkPipelineDynamicStateCreateInfo);
    }

    static struct GraphicsCreateInfo {
        @vkProp() {
            immutable VkPipelineCreateFlags flags;
            PipelineLayout layout;
            RenderPass renderPass;
            immutable uint subpass;
            Pipeline basePipelineHandle;
            immutable int basePipelineIndex;
        }

        @vkProp("pStages", "stageCount") {
            ShaderStageCreateInfo[] stages;
        }

        @vkProp("pVertexInputState") {
            const VertexInputStateCreateInfo vertexInputState;
        }

        @vkProp("pInputAssemblyState") {
            const InputAssemblyStateCreateInfo inputAssemblyState;
        }

        @vkProp("pTessellationState") {
            const VkPipelineTessellationStateCreateInfo tessellationState;
        }

        @vkProp("pViewportState") {
            const ViewportStateCreateInfo viewportState;
        }

        @vkProp("pRasterizationState") {
            const RasterizationStateCreateInfo rasterizationState;
        }

        @vkProp("pMultisampleState") {
            const MultisampleStateCreateInfo multisampleState;
        }

        @vkProp("pDepthStencilState") {
            const VkPipelineDepthStencilStateCreateInfo depthStencilState;
        }

        @vkProp("pColorBlendState") {
            const ColorBlendStateCreateInfo colorBlendState;
        }

        @vkProp("pDynamicState") {
            const DynamicStateCreateInfo dynamicState;
        }

        mixin VkTo!(VkGraphicsPipelineCreateInfo);
    }

    static struct ComputeCreateInfo {
        @vkProp() {
            VkPipelineCreateFlags flags;
            ShaderStageCreateInfo stage;
            PipelineLayout layout;
            Pipeline basePipelineHandle;
            int basePipelineIndex;
        }

        mixin VkTo!(VkComputePipelineCreateInfo);
    }

    private Device device;
    package VkPipeline pipeline;

    mixin ImplNameSetter!(device, pipeline, DebugReportObjectType.Pipeline);

    this(Device device, VkPipeline pipeline) {
        this.device = device;
        this.pipeline = pipeline;
    }

    ~this() {
        vkDestroyPipeline(device.device, pipeline, null);
    }

    mixin VkTo!(VkPipeline);

    static Pipeline[] create(Device device, GraphicsCreateInfo[] _infos) {

        auto infos = _infos.map!(i => i.vkTo()).array;
        VkPipeline[] pipelines = new VkPipeline[_infos.length];

        enforceVK(vkCreateGraphicsPipelines(device.device, null  /*pipeline cache */ ,
                cast(uint) infos.length, infos.ptr, null, pipelines.ptr));

        return pipelines.map!(p => new Pipeline(device, p)).array;
    }

    static Pipeline[] create(Device device, ComputeCreateInfo[] _infos) {

        auto infos = _infos.map!(i => i.vkTo()).array;
        VkPipeline[] pipelines = new VkPipeline[_infos.length];

        enforceVK(vkCreateComputePipelines(device.device, null  /*pipeline cache */ ,
                cast(uint) infos.length, infos.ptr, null, pipelines.ptr));

        return pipelines.map!(p => new Pipeline(device, p)).array;
    }
}
