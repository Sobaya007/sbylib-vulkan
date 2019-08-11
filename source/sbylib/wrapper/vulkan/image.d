module sbylib.wrapper.vulkan.image;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class Image {
    static struct CreateInfo {
        @vkProp() {
            VkImageCreateFlags flags;
            ImageType imageType;
            VkFormat format;
            VkExtent3D extent;
            uint mipLevels;
            uint arrayLayers;
            SampleCount samples;
            ImageTiling tiling;
            ImageUsage usage;
            SharingMode sharingMode;
            ImageLayout initialLayout;
        }

        @vkProp("pQueueFamilyIndices", "queueFamilyIndexCount") {
            const uint[] queueFamilyIndices;
        }

        mixin VkTo!(VkImageCreateInfo);
    }

    private Device device;
    VkImage image;
    private bool mustRelease;

    this(Device device, CreateInfo _info) {
        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateImage(device.device, &info, null, &image));
        enforce(image != VK_NULL_HANDLE);
        this.mustRelease = true;
    }

    this(VkImage image) {
        this.image = image;
        enforce(image != VK_NULL_HANDLE);
        this.mustRelease = false;
    }

    ~this() {
        if (mustRelease)
            vkDestroyImage(device.device, image, null);
    }

    mixin VkTo!(VkImage);
}
