module sbylib.wrapper.vulkan.swapchain;

import std;
import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.fence;
import sbylib.wrapper.vulkan.image;
import sbylib.wrapper.vulkan.surface;
import sbylib.wrapper.vulkan.util;

class Swapchain {
    static struct CreateInfo {
        @vkProp() {
            immutable VkSwapchainCreateFlagsKHR flags;
            Surface surface;
            immutable uint minImageCount;
            immutable VkFormat imageFormat;
            immutable VkColorSpaceKHR imageColorSpace;
            immutable VkExtent2D imageExtent;
            immutable uint imageArrayLayers;
            immutable ImageUsage imageUsage;
            immutable SharingMode imageSharingMode;
            immutable SurfaceTransform preTransform;
            immutable CompositeAlpha compositeAlpha;
            immutable PresentMode presentMode;
            immutable bool clipped;
            Swapchain oldSwapchain;
        }

        @vkProp("pQueueFamilyIndices", "queueFamilyIndexCount") {
            const uint[] queueFamilyIndices;
        }

        mixin VkTo!(VkSwapchainCreateInfoKHR);
    }

    private Device device;
    private VkSwapchainKHR swapchain;

    mixin ImplNameSetter!(device, swapchain, DebugReportObjectType.Swapchain);

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateSwapchainKHR(device.device, &info, null, &swapchain));
        enforce(swapchain != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroySwapchainKHR(device.device, swapchain, null);
    }

    mixin VkTo!(VkSwapchainKHR);

    Image[] getImages() {
        uint numSwapchainImage;
        vkGetSwapchainImagesKHR(device.device, swapchain, &numSwapchainImage, null);

        VkImage[] swapchainImages = new VkImage[numSwapchainImage];
        vkGetSwapchainImagesKHR(device.device, swapchain,
                &numSwapchainImage, swapchainImages.ptr);

        Image[] result = new Image[numSwapchainImage];
        foreach (i; 0..numSwapchainImage)
            result[i] = new Image(swapchainImages[i]);

        return result;
    }

    uint acquireNextImageIndex(ulong timeout, VkSemaphore semaphore, Fence fence) 
        in (device !is null)
        in (fence !is null)
    {
        uint imageIndex;
        enforceVK(vkAcquireNextImageKHR(device.device, swapchain, timeout,
                semaphore, fence.fence, &imageIndex));
        return imageIndex;
    }
}
