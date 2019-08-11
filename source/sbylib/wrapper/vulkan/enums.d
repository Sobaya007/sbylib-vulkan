module sbylib.wrapper.vulkan.enums;

import erupted;

enum SurfaceTransform {
    Identity = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR,
    Rotate90 = VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR,
    Rotate180 = VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR,
    Rotate270 = VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR,
    HorizontalMirror = VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR,
    HorizontalMirrorRotate90 = VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR,
    HorizontalMirrorRotate180 = VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR,
    HorizontalMirrorRotate270 = VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR,
    Ineherit = VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR,
}

enum CompositeAlpha {
    Opaque = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
    AlphaPreMultiplied = VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR,
    AlphaPostMultiplied
        = VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR, Inherit = VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR,
}

enum ImageUsage {
    TransferSrc = VK_IMAGE_USAGE_TRANSFER_SRC_BIT,
    TransferDst = VK_IMAGE_USAGE_TRANSFER_DST_BIT,
    Sampled = VK_IMAGE_USAGE_SAMPLED_BIT,
    Storate = VK_IMAGE_USAGE_STORAGE_BIT,
    ColorAttachment = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
    DepthStencilAttachment = VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT,
    TransientAttachment = VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT,
    InputAttachment = VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT,
    SharingRateImage = VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV,
    FragmentDensityMap = VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT,
}

enum SharingMode {
    Exclusive = VK_SHARING_MODE_EXCLUSIVE,
    Concurrent = VK_SHARING_MODE_CONCURRENT,
}

enum PresentMode {
    Immediate = VK_PRESENT_MODE_IMMEDIATE_KHR,
    Mailbox = VK_PRESENT_MODE_MAILBOX_KHR,
    FIFO = VK_PRESENT_MODE_FIFO_KHR,
    FIFORelaxed = VK_PRESENT_MODE_FIFO_RELAXED_KHR,
    SharedDemandRefresh = VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR,
    SharedContinuousRefresh = VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR,
}

enum ImageViewType {
    Type1D = VK_IMAGE_VIEW_TYPE_1D,
    Type2D = VK_IMAGE_VIEW_TYPE_2D,
    Type3D = VK_IMAGE_VIEW_TYPE_3D,
    TypeCube = VK_IMAGE_VIEW_TYPE_CUBE,
    Type1DArray = VK_IMAGE_VIEW_TYPE_1D_ARRAY,
    Type2DArray = VK_IMAGE_VIEW_TYPE_2D_ARRAY,
    TypeCubeArray = VK_IMAGE_VIEW_TYPE_CUBE_ARRAY,
}

enum ComponentSwizzle {
    Identity = VK_COMPONENT_SWIZZLE_IDENTITY,
    Zero = VK_COMPONENT_SWIZZLE_ZERO,
    One = VK_COMPONENT_SWIZZLE_ONE,
    R = VK_COMPONENT_SWIZZLE_R,
    G = VK_COMPONENT_SWIZZLE_G,
    B = VK_COMPONENT_SWIZZLE_B,
    A = VK_COMPONENT_SWIZZLE_A,
}

enum ImageAspect {
    Color = VK_IMAGE_ASPECT_COLOR_BIT,
    Depth = VK_IMAGE_ASPECT_DEPTH_BIT,
    Stencil = VK_IMAGE_ASPECT_STENCIL_BIT,
    Metadata = VK_IMAGE_ASPECT_METADATA_BIT,
    Plane0 = VK_IMAGE_ASPECT_PLANE_0_BIT,
    Plane1 = VK_IMAGE_ASPECT_PLANE_1_BIT,
    Plane2 = VK_IMAGE_ASPECT_PLANE_2_BIT,
    MemoryPlane0 = VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT,
    MemoryPlane1 = VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT,
    MemoryPlane2
        = VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT,
        MemoryPlane3 = VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT,
        Plane0KHR = VK_IMAGE_ASPECT_PLANE_0_BIT_KHR,
        Plane1KHR = VK_IMAGE_ASPECT_PLANE_1_BIT_KHR, Plane2KHR = VK_IMAGE_ASPECT_PLANE_2_BIT_KHR,
}

enum ShaderStage {
    Vertex = VK_SHADER_STAGE_VERTEX_BIT,
    TessellationControl = VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT,
    TessellationEvaluation = VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT,
    Geometry = VK_SHADER_STAGE_GEOMETRY_BIT,
    Fragment = VK_SHADER_STAGE_FRAGMENT_BIT,
    Task = VK_SHADER_STAGE_TASK_BIT_NV,
    Mesh = VK_SHADER_STAGE_MESH_BIT_NV,
    Compute = VK_SHADER_STAGE_COMPUTE_BIT,
    Raygen = VK_SHADER_STAGE_RAYGEN_BIT_NV,
    AnyHit = VK_SHADER_STAGE_ANY_HIT_BIT_NV,
    ClosestHit = VK_SHADER_STAGE_CLOSEST_HIT_BIT_NV,
    Miss = VK_SHADER_STAGE_MISS_BIT_NV,
    Intersection = VK_SHADER_STAGE_INTERSECTION_BIT_NV,
    Callable = VK_SHADER_STAGE_CALLABLE_BIT_NV,
}

enum VertexInputRate {
    Vertex = VK_VERTEX_INPUT_RATE_VERTEX,
    Instance = VK_VERTEX_INPUT_RATE_INSTANCE,
}

enum PrimitiveTopology {
    PointList = VK_PRIMITIVE_TOPOLOGY_POINT_LIST,
    LineList = VK_PRIMITIVE_TOPOLOGY_LINE_LIST,
    LineStrip = VK_PRIMITIVE_TOPOLOGY_LINE_STRIP,
    TriangleList = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
    TriangleStrip = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP,
    TriangleFan = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN,
    LineListWithAdjacency = VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY,
    LineStripWithAdjacency = VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY,
    TriangleListWithAdjacency = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY,
    TriangleStripWithAdajacency = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY,
    PatchList = VK_PRIMITIVE_TOPOLOGY_PATCH_LIST,
}

enum PolygonMode {
    Fill = VK_POLYGON_MODE_FILL,
    Line = VK_POLYGON_MODE_LINE,
    Point = VK_POLYGON_MODE_POINT,
    FillRectangle = VK_POLYGON_MODE_FILL_RECTANGLE_NV,
}

enum CullMode {
    None = VK_CULL_MODE_NONE,
    Front = VK_CULL_MODE_FRONT_BIT,
    Back = VK_CULL_MODE_BACK_BIT,
    FrontAndBack = VK_CULL_MODE_FRONT_AND_BACK,
}

enum FrontFace {
    CounterClockwise = VK_FRONT_FACE_COUNTER_CLOCKWISE,
    Clockwise = VK_FRONT_FACE_CLOCKWISE,
}

enum SampleCount {
    Count1 = VK_SAMPLE_COUNT_1_BIT,
    Count2 = VK_SAMPLE_COUNT_2_BIT,
    Count4 = VK_SAMPLE_COUNT_4_BIT,
    Count8 = VK_SAMPLE_COUNT_8_BIT,
    Count16 = VK_SAMPLE_COUNT_16_BIT,
    Count32 = VK_SAMPLE_COUNT_32_BIT,
    Count64 = VK_SAMPLE_COUNT_64_BIT,
}

enum AttachmentLoadOp {
    Load = VK_ATTACHMENT_LOAD_OP_LOAD,
    Clear = VK_ATTACHMENT_LOAD_OP_CLEAR,
    DontCare = VK_ATTACHMENT_LOAD_OP_DONT_CARE,
}

enum AttachmentStoreOp {
    Store = VK_ATTACHMENT_STORE_OP_STORE,
    DontCare = VK_ATTACHMENT_STORE_OP_DONT_CARE,
}

enum ImageLayout {
    Undefined = VK_IMAGE_LAYOUT_UNDEFINED,
    General = VK_IMAGE_LAYOUT_GENERAL,
    ColorAttachmentOptimal = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
    DepthStencilAttachmentOptimal = VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    DepthStencilReadOnlyOptimal = VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL,
    ShaderReadOnlyOptimal = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
    TransferSrcOptimal = VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
    TransferDstOptimal = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
    Preinitialized = VK_IMAGE_LAYOUT_PREINITIALIZED,
    DepthReadOnlyStencilAttachmentOptimal = VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL,
    DepthAttachmentStencilReadonlyOptimal = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL,
    PresentSrc = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
    SharedPresentSrc = VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR,
    ShadingRateOptimal = VK_IMAGE_LAYOUT_SHADING_RATE_OPTIMAL_NV,
    FragmentDensityMapOptimal = VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT,
    DepthReadOnlyStencilAttachmentOptimalKHR = VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR,
    DepthAttachmentStencilReaOnlyOptimalKHR = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR,
}

enum PipelineBindPoint {
    Graphics = VK_PIPELINE_BIND_POINT_GRAPHICS,
    Compute = VK_PIPELINE_BIND_POINT_COMPUTE,
    RayTracing = VK_PIPELINE_BIND_POINT_RAY_TRACING_NV,
}

enum PipelineStage {
    None = 0,
    TopOfPipe = VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT,
    DrawIndirect = VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT,
    VertexInput = VK_PIPELINE_STAGE_VERTEX_INPUT_BIT,
    VertexShader
        = VK_PIPELINE_STAGE_VERTEX_SHADER_BIT,
        TessellationControlShader = VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT,
        TessellationEvaluationShader = VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT,
        GeometryShader = VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT,
        FragmentShader = VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT,
        EarlyFragmentTests = VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT,
        LateFragmentTests = VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT,
        ColorAttachmentOutput = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,
        ComputeShader = VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        Transfer = VK_PIPELINE_STAGE_TRANSFER_BIT,
        BottomOfPipe = VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT,
        Host = VK_PIPELINE_STAGE_HOST_BIT, AllGraphics = VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT,
        AllCommands = VK_PIPELINE_STAGE_ALL_COMMANDS_BIT,
        TransformFeedback = VK_PIPELINE_STAGE_TRANSFORM_FEEDBACK_BIT_EXT,
        ConditionalRendering = VK_PIPELINE_STAGE_CONDITIONAL_RENDERING_BIT_EXT,
        CommandProcess = VK_PIPELINE_STAGE_COMMAND_PROCESS_BIT_NVX,
        ShadingRateImage = VK_PIPELINE_STAGE_SHADING_RATE_IMAGE_BIT_NV,
        RayTracingShader = VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_NV,
        AccelerationStructureBuild = VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_NV,
        TaskShader = VK_PIPELINE_STAGE_TASK_SHADER_BIT_NV,
        MeshShader = VK_PIPELINE_STAGE_MESH_SHADER_BIT_NV,
        FragmentDensityProcess = VK_PIPELINE_STAGE_FRAGMENT_DENSITY_PROCESS_BIT_EXT,
}

enum CommandBufferLevel {
    Primary = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
    Secondary = VK_COMMAND_BUFFER_LEVEL_SECONDARY,
}

enum BufferUsage {
    TransferSrc = VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
    TransferDst = VK_BUFFER_USAGE_TRANSFER_DST_BIT,
    UniformTexelBuffer = VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT,
    StorateTexelBuffer = VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT,
    UniformBuffer = VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
    StorageBuffer = VK_BUFFER_USAGE_STORAGE_BUFFER_BIT,
    IndexBuffer = VK_BUFFER_USAGE_INDEX_BUFFER_BIT,
    VertexBuffer = VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
    IndirectBuffer
        = VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT,
        TransformFeedbackBuffer = VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_BUFFER_BIT_EXT,
        TransformFeedbackCounterBuffer = VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_COUNTER_BUFFER_BIT_EXT,
        ConditionalRendering = VK_BUFFER_USAGE_CONDITIONAL_RENDERING_BIT_EXT,
        RayTracing = VK_BUFFER_USAGE_RAY_TRACING_BIT_NV,
        ShaderDeviceAddress = VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT_EXT,
}

enum LogicOp {
    Clear = VK_LOGIC_OP_CLEAR,
    And = VK_LOGIC_OP_AND,
    AndReverse = VK_LOGIC_OP_AND_REVERSE,
    Copy = VK_LOGIC_OP_COPY,
    AndInverted = VK_LOGIC_OP_AND_INVERTED,
    NoOp = VK_LOGIC_OP_NO_OP,
    Xor = VK_LOGIC_OP_XOR,
    Or = VK_LOGIC_OP_OR,
    Nor = VK_LOGIC_OP_NOR,
    Equivalent = VK_LOGIC_OP_EQUIVALENT,
    Invert = VK_LOGIC_OP_INVERT,
    OrReverse = VK_LOGIC_OP_OR_REVERSE,
    CopyInverted = VK_LOGIC_OP_COPY_INVERTED,
    OrInverted = VK_LOGIC_OP_OR_INVERTED,
    Nand = VK_LOGIC_OP_NAND,
    Set = VK_LOGIC_OP_SET,
}

enum BlendFactor {
    Zero = VK_BLEND_FACTOR_ZERO,
    One = VK_BLEND_FACTOR_ONE,
    SrcColor = VK_BLEND_FACTOR_SRC_COLOR,
    OneMInusSrcColor
        = VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR, DstColor = VK_BLEND_FACTOR_DST_COLOR,
        OneMinusDstColor = VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR,
        SrcAlpha = VK_BLEND_FACTOR_SRC_ALPHA,
        OneMinusSrcAlpha = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
        DstAlpha = VK_BLEND_FACTOR_DST_ALPHA, OneMinusDstAlpha = VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA,
        ConstantColor = VK_BLEND_FACTOR_CONSTANT_COLOR,
        OneMinusConstantColor = VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR,
        ConstantAlpha = VK_BLEND_FACTOR_CONSTANT_ALPHA,
        OneMinusConstantAlpha = VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA,
        SrcAlphaSaturate = VK_BLEND_FACTOR_SRC_ALPHA_SATURATE, Src1Color = VK_BLEND_FACTOR_SRC1_COLOR,
        OneMinusSrc1Color = VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR,
        Src1Alpha = VK_BLEND_FACTOR_SRC1_ALPHA,
        OneMinusSrc1Alpha = VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA,
}

enum BlendOp {
    Add = VK_BLEND_OP_ADD,
    Subtract = VK_BLEND_OP_SUBTRACT,
    ReverseSubtract
        = VK_BLEND_OP_REVERSE_SUBTRACT, Min = VK_BLEND_OP_MIN, Max = VK_BLEND_OP_MAX,
        Zero = VK_BLEND_OP_ZERO_EXT, Src = VK_BLEND_OP_SRC_EXT,
        Dst = VK_BLEND_OP_DST_EXT, SrcOver = VK_BLEND_OP_SRC_OVER_EXT,
        DstOver = VK_BLEND_OP_DST_OVER_EXT, SrcIn = VK_BLEND_OP_SRC_IN_EXT,
        DstIn = VK_BLEND_OP_DST_IN_EXT,
        SrcOut = VK_BLEND_OP_SRC_OUT_EXT,
        DstOut = VK_BLEND_OP_DST_OUT_EXT, SrcAtop = VK_BLEND_OP_SRC_ATOP_EXT,
        DstAtop = VK_BLEND_OP_DST_ATOP_EXT, Xor = VK_BLEND_OP_XOR_EXT,
        Multiply = VK_BLEND_OP_MULTIPLY_EXT,
        Screen = VK_BLEND_OP_SCREEN_EXT,
        Overlay = VK_BLEND_OP_OVERLAY_EXT, Darken = VK_BLEND_OP_DARKEN_EXT,
        Lighten = VK_BLEND_OP_LIGHTEN_EXT, Colordodge = VK_BLEND_OP_COLORDODGE_EXT,
        Colorburn = VK_BLEND_OP_COLORBURN_EXT,
        Hardlight = VK_BLEND_OP_HARDLIGHT_EXT,
        Softlight = VK_BLEND_OP_SOFTLIGHT_EXT,
        Difference = VK_BLEND_OP_DIFFERENCE_EXT, Exclusion = VK_BLEND_OP_EXCLUSION_EXT,
        Invert = VK_BLEND_OP_INVERT_EXT, InvertRGB = VK_BLEND_OP_INVERT_RGB_EXT,
        Lineardodge = VK_BLEND_OP_LINEARDODGE_EXT,
        Linearburn = VK_BLEND_OP_LINEARBURN_EXT,
        Vividlight = VK_BLEND_OP_VIVIDLIGHT_EXT,
        Linearlight = VK_BLEND_OP_LINEARLIGHT_EXT, Pinlight = VK_BLEND_OP_PINLIGHT_EXT,
        Hardmix = VK_BLEND_OP_HARDMIX_EXT, HSLHue = VK_BLEND_OP_HSL_HUE_EXT,
        HSLSaturation = VK_BLEND_OP_HSL_SATURATION_EXT,
        HSLColor = VK_BLEND_OP_HSL_COLOR_EXT,
        HSLLuminosity = VK_BLEND_OP_HSL_LUMINOSITY_EXT,
        Plus = VK_BLEND_OP_PLUS_EXT, PlusClamped = VK_BLEND_OP_PLUS_CLAMPED_EXT,
        PlusClampedAlpha = VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT,
        PlusDarker = VK_BLEND_OP_PLUS_DARKER_EXT,
        Minus = VK_BLEND_OP_MINUS_EXT,
        MinusClamped = VK_BLEND_OP_MINUS_CLAMPED_EXT,
        Contrast = VK_BLEND_OP_CONTRAST_EXT, InvertOVG = VK_BLEND_OP_INVERT_OVG_EXT,
        Red = VK_BLEND_OP_RED_EXT, Green = VK_BLEND_OP_GREEN_EXT, Blue = VK_BLEND_OP_BLUE_EXT,
}

enum ColorComponent {
    R = VK_COLOR_COMPONENT_R_BIT,
    G = VK_COLOR_COMPONENT_G_BIT,
    B = VK_COLOR_COMPONENT_B_BIT,
    A = VK_COLOR_COMPONENT_A_BIT,
}

enum SubpassContents {
    Inline = VK_SUBPASS_CONTENTS_INLINE,
    SecondaryCommandBuffers = VK_SUBPASS_CONTENTS_SECONDARY_COMMAND_BUFFERS,
}

enum DescriptorType {
    Sampler = VK_DESCRIPTOR_TYPE_SAMPLER,
    CombinedImageSampler = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
    SampledImage = VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE,
    StorageImage = VK_DESCRIPTOR_TYPE_STORAGE_IMAGE,
    UniformTexelBuffer = VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER,
    StorageTexelBuffer = VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER,
    UniformBuffer = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
    StorageBuffer = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER,
    UniformBufferDynamic = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC,
    StorageBufferDybamic = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC,
    InputAttachment = VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT,
    InlineUinformBlock = VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT,
    AccelerationStructure = VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV,
}

enum ImageType {
    Type1D = VK_IMAGE_TYPE_1D,
    Type2D = VK_IMAGE_TYPE_2D,
    Type3D = VK_IMAGE_TYPE_3D,
}

enum ImageTiling {
    Optimal = VK_IMAGE_TILING_OPTIMAL,
    Linear = VK_IMAGE_TILING_LINEAR,
    DRMFormatModifier = VK_IMAGE_TILING_DRM_FORMAT_MODIFIER_EXT,
}

enum AccessFlags {
    IndirectCommandRead = VK_ACCESS_INDIRECT_COMMAND_READ_BIT,
    IndexRead = VK_ACCESS_INDEX_READ_BIT,
    VertxAttributeRead
        = VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT, UniformRead = VK_ACCESS_UNIFORM_READ_BIT,
        InputAttachmentRead = VK_ACCESS_INPUT_ATTACHMENT_READ_BIT,
        ShaderRead = VK_ACCESS_SHADER_READ_BIT,
        ShaderWrite = VK_ACCESS_SHADER_WRITE_BIT,
        ColorAttachmentRead = VK_ACCESS_COLOR_ATTACHMENT_READ_BIT,
        ColorAttachmentWrite = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT,
        DepthStencilAttachmentRead = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT,
        DepthStencilAttachmentWrite = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,
        TransferRead = VK_ACCESS_TRANSFER_READ_BIT,
        TransferWrite = VK_ACCESS_TRANSFER_WRITE_BIT,
        HostRead = VK_ACCESS_HOST_READ_BIT,
        HostWrite = VK_ACCESS_HOST_WRITE_BIT, MemoryRead = VK_ACCESS_MEMORY_READ_BIT,
        MemoryWrite = VK_ACCESS_MEMORY_WRITE_BIT,
        TransformFeedbackWrite = VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT,
        TransformFeedbackRead = VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT,
        TransformFeedbackCounterWrite = VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT,
        TransformFeedbackCounterRead = VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT,
        CommandProcessRead = VK_ACCESS_COMMAND_PROCESS_READ_BIT_NVX,
        CommandProcessWrite = VK_ACCESS_COMMAND_PROCESS_WRITE_BIT_NVX,
        ColorAttachmentReadNoncoherent = VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT,
        ShadingRateImageRead = VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV,
        AccelerationStructureRead = VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV,
        AccelerationStructureWrite = VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV,
        FragmentDensityMapRead = VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT,
}

enum SamplerFilter {
    Nearest = VK_FILTER_NEAREST,
    Linear = VK_FILTER_LINEAR,
    Cubic = VK_FILTER_CUBIC_IMG,
}

enum SamplerMipmapMode {
    Nearest = VK_SAMPLER_MIPMAP_MODE_NEAREST,
    Linear = VK_SAMPLER_MIPMAP_MODE_LINEAR,
}

enum SamplerAddressMode {
    Repeat = VK_SAMPLER_ADDRESS_MODE_REPEAT,
    MirroredRepeat = VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT,
    ClampToEdge = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
    ClampToBorder = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER,
    MirrorClampToEdge = VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE,
}

enum CompareOp {
    Never = VK_COMPARE_OP_NEVER,
    Less = VK_COMPARE_OP_LESS,
    Equal = VK_COMPARE_OP_EQUAL,
    LessOrEqual = VK_COMPARE_OP_LESS_OR_EQUAL,
    Greater = VK_COMPARE_OP_GREATER,
    NotEqual = VK_COMPARE_OP_NOT_EQUAL,
    GreaterOrEqual = VK_COMPARE_OP_GREATER_OR_EQUAL,
    Always = VK_COMPARE_OP_ALWAYS,
}

enum BorderColor {
    FloatTransparentBlack = VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK,
    IntTransparentBlack = VK_BORDER_COLOR_INT_TRANSPARENT_BLACK,
    FloatOpaqueBlack = VK_BORDER_COLOR_FLOAT_OPAQUE_BLACK,
    IntOpaqueBlack = VK_BORDER_COLOR_INT_OPAQUE_BLACK,
    FloatOpaqueWhite = VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE,
    IntOpaqueWhite = VK_BORDER_COLOR_INT_OPAQUE_WHITE,
}

enum DependencyFlags {
    ByRegion = VK_DEPENDENCY_BY_REGION_BIT,
    DeviceGroup = VK_DEPENDENCY_DEVICE_GROUP_BIT,
    ViewLocal = VK_DEPENDENCY_VIEW_LOCAL_BIT,
}

enum IndexType {
    Uint16 = VK_INDEX_TYPE_UINT16,
    Uint32 = VK_INDEX_TYPE_UINT32,
    None = VK_INDEX_TYPE_NONE_NV,
    Uint8 = VK_INDEX_TYPE_UINT8_EXT,
}
