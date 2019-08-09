module sbylib.wrapper.vulkan.buffer;

import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.util;

class Buffer {
    static struct CreateInfo {
        @vkProp() {
            immutable VkBufferCreateFlags flags;
            immutable VkDeviceSize size;
            immutable BufferUsage usage;
            immutable SharingMode sharingMode;
        }

        @vkProp("pQueueFamilyIndices", "queueFamilyIndexCount") {
            uint[] queueFamilyIndices;
        }

        const mixin VkTo!(VkBufferCreateInfo);
    }

    private Device device;
    package VkBuffer buffer;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateBuffer(device.device, &info, null, &buffer));
        enforce(buffer != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyBuffer(device.device, buffer, null);
    }

    mixin VkTo!(VkBuffer);
}
