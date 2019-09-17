module sbylib.wrapper.vulkan.buffer;

import std;
import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.devicememory;
import sbylib.wrapper.vulkan.physicaldevice;
import sbylib.wrapper.vulkan.memoryproperties;
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

    mixin ImplNameSetter!(device, buffer, DebugReportObjectType.Buffer);

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

    DeviceMemory allocateMemory(PhysicalDevice gpu, MemoryProperties.MemoryType.Flags memoryTypeFlag) {
        DeviceMemory.AllocateInfo deviceMemoryAllocInfo = {
            allocationSize: device.getBufferMemoryRequirements(this).size,
            memoryTypeIndex: cast(uint)gpu.getMemoryProperties().memoryTypes
                .countUntil!(p => p.supports(memoryTypeFlag))
        };
        enforce(deviceMemoryAllocInfo.memoryTypeIndex != -1);
        return new DeviceMemory(device, deviceMemoryAllocInfo);
    }
}
