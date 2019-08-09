module sbylib.wrapper.vulkan.renderpass;

import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class RenderPass {
    static struct AttachmentDescription {
        @vkProp() {
            VkAttachmentDescriptionFlags flags;
            VkFormat format;
            SampleCount samples;
            AttachmentLoadOp loadOp;
            AttachmentStoreOp storeOp;
            AttachmentLoadOp stencilLoadOp;
            AttachmentStoreOp stencilStoreOp;
            ImageLayout initialLayout;
            ImageLayout finalLayout;
        }

        const mixin VkTo!(VkAttachmentDescription);
    }

    static struct SubpassDescription {

        static struct AttachmentReference {
            @vkProp() {
                uint attachment;
                ImageLayout layout;
            }
            
            const mixin VkTo!(VkAttachmentReference);
        }

        @vkProp() {
            immutable VkSubpassDescriptionFlags flags;
            immutable PipelineBindPoint pipelineBindPoint;
        }

        @vkProp("pInputAttachments", "inputAttachmentCount") {
            const AttachmentReference[] inputAttachments;
        }

        @vkProp("pColorAttachments", "colorAttachmentCount") {
            const AttachmentReference[] colorAttachments;
        }

        @vkProp("pResolveAttachments") {
            const AttachmentReference[] resolveAttachments;
        }

        @vkProp("pDepthStencilAttachment") {
            const AttachmentReference[] depthStencilAttachments;
        }

        @vkProp("pPreserveAttachments", "preserveAttachmentCount") {
            const uint[] preserveAttachments;
        }

        invariant(resolveAttachments is null || resolveAttachments.length == colorAttachments
                .length);
        invariant(depthStencilAttachments is null
                || depthStencilAttachments.length == colorAttachments.length);

        const mixin VkTo!(VkSubpassDescription);
    }

    static struct CreateInfo {
        @vkProp() {
            immutable VkRenderPassCreateFlags flags;
        }

        @vkProp("pAttachments", "attachmentCount") {
            const AttachmentDescription[] attachments;
        }

        @vkProp("pSubpasses", "subpassCount") {
            const SubpassDescription[] subpasses;
        }

        @vkProp("pDependencies", "dependencyCount") {
            const VkSubpassDependency[] dependencies;
        }

        const mixin VkTo!(VkRenderPassCreateInfo);
    }

    private Device device;
    private VkRenderPass renderPass;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateRenderPass(device.device, &info, null, &renderPass));
        enforce(renderPass != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyRenderPass(device.device, renderPass, null);
    }

    mixin VkTo!(VkRenderPass);
}
