module sbylib.wrapper.vulkan.memoryproperties;

import std;
import erupted;
import sbylib.wrapper.vulkan.util;

struct MemoryProperties {
    static struct MemoryType {
        enum Flags {
            DeviceLocal = VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
            HostVisible = VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
            HostCoherent = VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
            HostCached = VK_MEMORY_PROPERTY_HOST_CACHED_BIT,
            LazilyAllocated = VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT,
            Protected = VK_MEMORY_PROPERTY_PROTECTED_BIT,
        }

        @vkProp() {
            BitFlags!Flags propertyFlags;
            uint heapIndex;
        }

        mixin VkFrom!(VkMemoryType);

        bool supports(Flags flag) const {
            return cast(bool)(this.propertyFlags & flag);
        }
    }

    static struct MemoryHeap {
        enum Flags {
            DeviceLocal = VK_MEMORY_HEAP_DEVICE_LOCAL_BIT,
            MultiInstance = VK_MEMORY_HEAP_MULTI_INSTANCE_BIT,
            MultiInstanceKHR = VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR,
        }

        @vkProp() {
            VkDeviceSize size;
            BitFlags!Flags flags;
        }

        mixin VkFrom!(VkMemoryHeap);
    }

    @vkProp("memoryTypes", "memoryTypeCount") {
        const MemoryType[] memoryTypes;
    }

    @vkProp("memoryHeaps", "memoryHeapCount") {
        const MemoryHeap[] memoryHeaps;
    }

    mixin VkFrom!(VkPhysicalDeviceMemoryProperties);
}
