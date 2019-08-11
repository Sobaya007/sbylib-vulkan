module sbylib.wrapper.vulkan.commandbuffer;

import std;
import erupted;
import sbylib.wrapper.vulkan.buffer;
import sbylib.wrapper.vulkan.commandpool;
import sbylib.wrapper.vulkan.descriptorset;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.framebuffer;
import sbylib.wrapper.vulkan.image;
import sbylib.wrapper.vulkan.renderpass;
import sbylib.wrapper.vulkan.pipeline;
import sbylib.wrapper.vulkan.pipelinelayout;
import sbylib.wrapper.vulkan.util;

class CommandBuffer {
    static struct AllocateInfo {
        @vkProp() {
            CommandPool commandPool;
            immutable CommandBufferLevel level;
            immutable uint commandBufferCount;
        }

        mixin VkTo!(VkCommandBufferAllocateInfo);
    }

    static struct BeginInfo {
        @vkProp() {
            immutable BitFlags!Flags flags;
        }

        @vkProp("pInheritanceInfo") {
            InheritanceInfo inheritanceInfo;
        }

        enum Flags {
            OneTimeSubmit = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
            RenderPassContinue = VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT,
            SimultaneousUse = VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT,
        }

        mixin VkTo!(VkCommandBufferBeginInfo);
    }

    static struct InheritanceInfo {
        @vkProp() {
            RenderPass renderPass;
            immutable uint subpass;
            Framebuffer framebuffer;
            immutable bool occlusionQueryEnable;
            immutable VkQueryControlFlags queryFlags;
            immutable VkQueryPipelineStatisticFlags pipelineStatistics;
        }

        mixin VkTo!(VkCommandBufferInheritanceInfo);
    }

    static struct RenderPassBeginInfo {
        @vkProp() {
            RenderPass renderPass;
            Framebuffer framebuffer;
            VkRect2D renderArea;
        }

        @vkProp("pClearValues", "clearValueCount") {
            const VkClearValue[] clearValues;
        }

        mixin VkTo!(VkRenderPassBeginInfo);
    }

    private Device device;
    private CommandPool commandPool;
    private VkCommandBuffer commandBuffer;

    private this(Device device, CommandPool commandPool, VkCommandBuffer commandBuffer) {
        import std.exception : enforce;

        this.device = device;
        this.commandPool = commandPool;
        this.commandBuffer = commandBuffer;
    }

    ~this() {
        vkFreeCommandBuffers(device.device, commandPool.commandPool, 1, &commandBuffer);
    }

    mixin VkTo!(VkCommandBuffer);

    static CommandBuffer[] allocate(Device device, AllocateInfo _info) {
        VkCommandBuffer[] commandBuffers = new VkCommandBuffer[_info.commandBufferCount];

        auto info = _info.vkTo();

        enforceVK(vkAllocateCommandBuffers(device.device, &info, commandBuffers.ptr));

        return commandBuffers.map!(cb => new CommandBuffer(device, _info.commandPool, cb)).array;
    }

    void begin(BeginInfo _info) {
        auto info = _info.vkTo();
        vkBeginCommandBuffer(commandBuffer, &info);
    }

    void end() {
        enforceVK(vkEndCommandBuffer(commandBuffer));
    }

    void cmdPipelineBarrier(PipelineStage srcStageMask,
            PipelineStage dstStageMask, VkDependencyFlags dependencyFlags,
            VkMemoryBarrier[] memoryBarriers, VkBufferMemoryBarrier[] bufferMemoryBarriers,
            VkImageMemoryBarrier[] imageMemoryBarriers) {

        vkCmdPipelineBarrier(commandBuffer, srcStageMask, dstStageMask,
                dependencyFlags, cast(uint) memoryBarriers.length,
                memoryBarriers.ptr, cast(uint) bufferMemoryBarriers.length, bufferMemoryBarriers.ptr,
                cast(uint) imageMemoryBarriers.length, imageMemoryBarriers.ptr);
    }

    void cmdBeginRenderPass(RenderPassBeginInfo _info, SubpassContents subpassContents) {
        auto info = _info.vkTo();
        vkCmdBeginRenderPass(commandBuffer, &info, subpassContents);
    }

    void cmdEndRenderPass() {
        vkCmdEndRenderPass(commandBuffer);
    }

    void cmdBindPipeline(PipelineBindPoint pipelineBindPoint, Pipeline pipeline) {
        vkCmdBindPipeline(commandBuffer, pipelineBindPoint, pipeline.pipeline);
    }

    void cmdSetViewport(uint N)(uint firstViewport, const VkViewport[N] viewports) {
        vkCmdSetViewport(commandBuffer, firstViewport, N, viewports.ptr);
    }

    void cmdSetScissor(uint N)(uint firstScissor, const VkRect2D[N] scissors) {
        vkCmdSetScissor(commandBuffer, firstScissor, N, scissors.ptr);
    }

    void cmdBindVertexBuffers(uint N)(uint firstBinding, Buffer[N] _buffers,
            const VkDeviceSize[N] offsets) {
        VkBuffer[N] buffers;
        static foreach (i; 0 .. N)
            buffers[i] = _buffers[i].buffer;

        vkCmdBindVertexBuffers(commandBuffer, firstBinding, N, buffers.ptr, offsets.ptr);
    }

    void cmdBindIndexBuffer(Buffer buffer,VkDeviceSize offset, IndexType indexType) {
        vkCmdBindIndexBuffer(commandBuffer, buffer.buffer, offset, indexType);
    }

    void cmdBindDescriptorSets(uint N, uint M)(PipelineBindPoint pipelineBindPoint, PipelineLayout layout,
            uint firstSet, const DescriptorSet[N] _descriptorSets, const uint[M] dynamicOffsets) {
        VkDescriptorSet[N] descriptorSets;
        static foreach (i; 0..N)
            descriptorSets[i] = cast(VkDescriptorSet)_descriptorSets[i].vkTo();

        vkCmdBindDescriptorSets(commandBuffer, pipelineBindPoint, layout.pipelineLayout, firstSet,
                cast(uint) descriptorSets.length, descriptorSets.ptr,
                cast(uint) dynamicOffsets.length, dynamicOffsets.ptr);
    }

    void cmdBindDescriptorSets(uint N)(PipelineBindPoint pipelineBindPoint, PipelineLayout layout,
            uint firstSet, const DescriptorSet[N] _descriptorSets) {
        uint[0] dummy;
        cmdBindDescriptorSets(pipelineBindPoint, layout, firstSet, _descriptorSets, dummy);
    }

    void cmdDraw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance) {
        vkCmdDraw(commandBuffer, vertexCount, instanceCount, firstVertex, firstInstance);
    }

    void cmdDrawIndexed(uint indexCount, uint instanceCount, uint firstIndex, int vertexOffset, uint firstInstance) {
        vkCmdDrawIndexed(commandBuffer, indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
    }

    void cmdDispatch(uint groupCountX, uint groupCountY, uint groupCountZ) {
        vkCmdDispatch(commandBuffer, groupCountX, groupCountY, groupCountZ);
    }

    void cmdCopyBuffer(Buffer src, Buffer dst, const VkBufferCopy[] regions) {
        vkCmdCopyBuffer(commandBuffer, src.buffer, dst.buffer, cast(uint)regions.length, regions.ptr);
    }

    void cmdCopyBufferToImage(uint N)(Buffer src, Image dst, ImageLayout layout, const VkBufferImageCopy[N] regions) {
        vkCmdCopyBufferToImage(commandBuffer, src.buffer, dst.image, layout, N, regions.ptr);
    }

    void cmdBlitImage(uint N)(Image srcImage, ImageLayout srcImageLayout, Image dstImage, ImageLayout dstImageLayout, VkImageBlit[N] regions, SamplerFilter filter) {
        vkCmdBlitImage(commandBuffer, srcImage.image, srcImageLayout, dstImage.image, dstImageLayout, N, regions.ptr, filter);
    }

    void cmdClearAttachments(uint N, uint M)(const VkClearAttachment[N] attachments, const VkClearRect[M] rects) {
        vkCmdClearAttachments(commandBuffer, N, attachments.ptr, M, rects.ptr);
    }

    void cmdExecuteCommands(uint N)(CommandBuffer[N] _commandBuffers) {
        VkCommandBuffer[N] commandBuffers;
        static foreach (i; 0..N) {
            commandBuffers[i] = _commandBuffers[i].vkTo();
        }
        vkCmdExecuteCommands(commandBuffer, N, commandBuffers.ptr);
    }
}
