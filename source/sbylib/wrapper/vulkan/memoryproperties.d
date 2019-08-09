module sbylib.wrapper.vulkan.memoryproperties;

import std;
import erupted;
import sbylib.wrapper.vulkan.util;

struct MemoryProperties {
    static struct MemoryHeap {
        enum Flags {
            DeviceLocal = VK_MEMORY_HEAP_DEVICE_LOCAL_BIT,
            MultiInstance = VK_MEMORY_HEAP_MULTI_INSTANCE_BIT,
            MultiInstanceKHR = VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR,
        }

        @vkProp() {
            VkDeviceSize       size;
            BitFlags!Flags  flags;
        }

        mixin VkFrom!(VkMemoryHeap);
    }
    @vkProp("memoryTypes", "memoryTypeCount") {
        const VkMemoryType[] memoryTypes;
    }

    @vkProp("memoryHeaps", "memoryHeapCount") {
        const MemoryHeap[] memoryHeaps;
    }

    mixin VkFrom!(VkPhysicalDeviceMemoryProperties);
}
