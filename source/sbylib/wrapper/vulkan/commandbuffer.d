module sbylib.wrapper.vulkan.commandbuffer;

import std;
import erupted;
import sbylib.wrapper.vulkan.buffer;
import sbylib.wrapper.vulkan.commandpool;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.framebuffer;
import sbylib.wrapper.vulkan.renderpass;
import sbylib.wrapper.vulkan.pipeline;
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
            immutable VkCommandBufferUsageFlags flags;
        }

        @vkProp("pInheritanceInfo") {
            InheritanceInfo inheritanceInfo;
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

    void cmdPipelineBarrier(VkPipelineStageFlags srcStageMask,
            VkPipelineStageFlags dstStageMask, VkDependencyFlags dependencyFlags,
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

    void cmdDraw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance) {
        vkCmdDraw(commandBuffer, vertexCount, instanceCount, firstVertex, firstInstance);
    }
}
