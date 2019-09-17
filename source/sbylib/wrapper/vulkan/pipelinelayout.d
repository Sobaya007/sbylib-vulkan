module sbylib.wrapper.vulkan.pipelinelayout;

import erupted;
import sbylib.wrapper.vulkan.descriptorsetlayout;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class PipelineLayout {
    static struct CreateInfo {
        @vkProp() {
            immutable VkPipelineLayoutCreateFlags flags;
        }

        @vkProp("pSetLayouts", "setLayoutCount") {
            const DescriptorSetLayout[] setLayouts;
        }

        @vkProp("pPushConstantRanges", "pushConstantRangeCount") {
            const VkPushConstantRange[] pushConstantRanges;
        }

        const mixin VkTo!(VkPipelineLayoutCreateInfo);
    }

    private Device device;
    package VkPipelineLayout pipelineLayout;

    mixin ImplNameSetter!(device, pipelineLayout, DebugReportObjectType.PipelineLayout);

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreatePipelineLayout(device.device, &info, null, &pipelineLayout));
        enforce(pipelineLayout != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyPipelineLayout(device.device, pipelineLayout, null);
    }

    mixin VkTo!(VkPipelineLayout);
}
