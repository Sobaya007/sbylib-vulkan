module sbylib.wrapper.vulkan.descriptorpool;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class DescriptorPool {
    static struct CreateInfo {

        static struct DescriptorPoolSize {
            @vkProp() {
                DescriptorType type;
                uint descriptorCount;
            }

            const mixin VkTo!(VkDescriptorPoolSize);
        }

        @vkProp() {
            VkDescriptorPoolCreateFlags flags;
            uint32_t maxSets;
        }

        @vkProp("pPoolSizes", "poolSizeCount") {
            const DescriptorPoolSize[] poolSizes;
        }

        const mixin VkTo!(VkDescriptorPoolCreateInfo);
    }

    private Device device;
    package VkDescriptorPool descriptorPool;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateDescriptorPool(device.device, &info, null, &descriptorPool));
        enforce(descriptorPool != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyDescriptorPool(device.device, descriptorPool, null);
    }

    mixin VkTo!(VkDescriptorPool);
}
