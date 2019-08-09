module sbylib.wrapper.vulkan.physicaldevice;

import std;
import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.memoryproperties;
import sbylib.wrapper.vulkan.queuefamilyproperties;
import sbylib.wrapper.vulkan.surface;
import sbylib.wrapper.vulkan.surfacecapabilities;
import sbylib.wrapper.vulkan.util;

class PhysicalDevice {

    package VkPhysicalDevice physDevice;

    this(VkPhysicalDevice physDevice) {
        this.physDevice = physDevice;
    }

    QueueFamilyProperties[] getQueueFamilyProperties() {
        import std.exception : enforce;

        uint numQueues;
        vkGetPhysicalDeviceQueueFamilyProperties(physDevice, &numQueues, null);
        enforce(numQueues >= 1, "No queue was found");

        auto queueFamilyProperties = new VkQueueFamilyProperties[](numQueues);
        vkGetPhysicalDeviceQueueFamilyProperties(physDevice, &numQueues,
                queueFamilyProperties.ptr);
        assert(numQueues == queueFamilyProperties.length);

        return queueFamilyProperties.map!(p => QueueFamilyProperties(p)).array;
    }

    bool getSurfaceSupport(ref Surface surface) {
        VkBool32 surfaceSupport;
        enforceVK(vkGetPhysicalDeviceSurfaceSupportKHR(physDevice, 0,
                surface.surface, &surfaceSupport));
        return surfaceSupport == VK_TRUE;
    }

    SurfaceCapabilities getSurfaceCapabilities(ref Surface surface) {
        VkSurfaceCapabilitiesKHR surfaceCapabilities;
        vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physDevice, surface.surface,
                &surfaceCapabilities);
        return SurfaceCapabilities(surfaceCapabilities);
    }

    VkSurfaceFormatKHR[] getSurfaceFormats(ref Surface surface) {
        uint numSurfaceFormats;
        vkGetPhysicalDeviceSurfaceFormatsKHR(physDevice, surface.surface,
                &numSurfaceFormats, null);

        auto surfaceFormats = new VkSurfaceFormatKHR[numSurfaceFormats];
        vkGetPhysicalDeviceSurfaceFormatsKHR(physDevice, surface.surface,
                &numSurfaceFormats, surfaceFormats.ptr);

        return surfaceFormats;
    }

    PresentMode[] getSurfacePresentModes(ref Surface surface) {
        uint numPresentMode;
        vkGetPhysicalDeviceSurfacePresentModesKHR(physDevice, surface.surface,
                &numPresentMode, null);

        auto presentModes = new VkPresentModeKHR[numPresentMode];
        vkGetPhysicalDeviceSurfacePresentModesKHR(physDevice, surface.surface,
                &numPresentMode, presentModes.ptr);

        return presentModes
            .map!(pm => cast(uint)pm)
            .map!(to!PresentMode)
            .array;
    }

    MemoryProperties getMemoryProperties() {
        VkPhysicalDeviceMemoryProperties memProps;
        vkGetPhysicalDeviceMemoryProperties(physDevice, &memProps);
        return MemoryProperties(memProps);
    }
}
