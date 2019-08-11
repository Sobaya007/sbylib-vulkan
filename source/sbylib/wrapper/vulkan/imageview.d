module sbylib.wrapper.vulkan.imageview;

import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.image;
import sbylib.wrapper.vulkan.util;

class ImageView {
    static struct CreateInfo {
        @vkProp() {
            immutable VkImageViewCreateFlags flags;
            Image image;
            immutable ImageViewType viewType;
            immutable VkFormat format;
            immutable VkComponentMapping components;
            VkImageSubresourceRange subresourceRange;
        }

        mixin VkTo!(VkImageViewCreateInfo);
    }

    private Device device;
    private VkImageView imageView;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateImageView(device.device, &info, null, &imageView));
        enforce(imageView != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyImageView(device.device, imageView, null);
    }

    mixin VkTo!(VkImageView);
}
