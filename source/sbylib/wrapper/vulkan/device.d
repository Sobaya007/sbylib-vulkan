module sbylib.wrapper.vulkan.device;

import erupted;
import sbylib.wrapper.vulkan.buffer;
import sbylib.wrapper.vulkan.physicaldevice;
import sbylib.wrapper.vulkan.queue;
import sbylib.wrapper.vulkan.util;

class Device {
    static struct QueueCreateInfo {
        @vkProp("pQueuePriorities", "queueCount") {
            const float[] queuePriorities;
        }
        @vkProp() {
            immutable uint queueFamilyIndex;
        }

        const mixin VkTo!(VkDeviceQueueCreateInfo);
    }

    static struct DeviceCreateInfo {
        @vkProp() {
            immutable VkDeviceCreateFlags flags;
            const(VkPhysicalDeviceFeatures)* pEnabledFeatures;
        }
        @vkProp("pQueueCreateInfos", "queueCreateInfoCount") {
            QueueCreateInfo[] queueCreateInfos;
        }
        @vkProp("ppEnabledLayerNames", "enabledLayerCount") {
            const string[] enabledLayerNames;
        }
        @vkProp("ppEnabledExtensionNames", "enabledExtensionCount") {
            const string[] enabledExtensionNames;
        }

        const mixin VkTo!(VkDeviceCreateInfo);
    }

    package VkDevice device;
    private PhysicalDevice gpu;

    this(PhysicalDevice gpu, DeviceCreateInfo info) {
        import std.exception : enforce;

        this.gpu = gpu;

        VkDeviceCreateInfo deviceCreateInfo = info.vkTo();
        enforceVK(vkCreateDevice(gpu.physDevice, &deviceCreateInfo, null, &device));
        enforce(device != VK_NULL_HANDLE);

        loadDeviceLevelFunctions(device);
    }

    ~this() {
        vkDeviceWaitIdle(device);
        vkDestroyDevice(device, null);
    }

    Queue getQueue(uint graphicsQueueFamilyIndex, uint queueIndex) {
        VkQueue queue;
        vkGetDeviceQueue(device, graphicsQueueFamilyIndex, queueIndex, &queue);
        return new Queue(queue);
    }

    VkMemoryRequirements getBufferMemoryRequirements(Buffer buffer) {
        VkMemoryRequirements memreq;
        vkGetBufferMemoryRequirements(device, buffer.buffer, &memreq);
        return memreq;
    }
}
