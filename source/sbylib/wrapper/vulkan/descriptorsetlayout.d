module sbylib.wrapper.vulkan.descriptorsetlayout;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class DescriptorSetLayout {
    static struct CreateInfo {

        static struct Binding {
            @vkProp() {
                uint binding;
                DescriptorType descriptorType;
                uint descriptorCount;
                BitFlags!ShaderStage stageFlags;
                const(VkSampler)* pImmutableSamplers;
            }

            const mixin VkTo!(VkDescriptorSetLayoutBinding);
        }

        @vkProp() {
            VkDescriptorSetLayoutCreateFlags flags;
        }

        @vkProp("pBindings", "bindingCount") {
            const Binding[] bindings;
        }

        const mixin VkTo!(VkDescriptorSetLayoutCreateInfo);
    }

    private Device device;
    package VkDescriptorSetLayout descriptorSetLayout;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateDescriptorSetLayout(device.device, &info, null, &descriptorSetLayout));
        enforce(descriptorSetLayout != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyDescriptorSetLayout(device.device, descriptorSetLayout, null);
    }

    mixin VkTo!(VkDescriptorSetLayout);
}
