module sbylib.wrapper.vulkan.framebuffer;

import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.imageview;
import sbylib.wrapper.vulkan.renderpass;
import sbylib.wrapper.vulkan.util;

class Framebuffer {
    static struct CreateInfo {
        @vkProp() {
            immutable VkFramebufferCreateFlags flags;
            RenderPass renderPass;
            immutable uint32_t width;
            immutable uint32_t height;
            immutable uint32_t layers;
        }

        @vkProp("pAttachments", "attachmentCount") {
            ImageView[] attachments;
        }

        mixin VkTo!(VkFramebufferCreateInfo);
    }

    private Device device;
    private VkFramebuffer framebuffer;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateFramebuffer(device.device, &info, null, &framebuffer));
        enforce(framebuffer != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyFramebuffer(device.device, framebuffer, null);
    }

    mixin VkTo!(VkFramebuffer);
}
