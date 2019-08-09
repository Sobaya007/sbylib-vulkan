module sbylib.wrapper.vulkan.queue;

import erupted;
import sbylib.wrapper.vulkan.commandbuffer;
import sbylib.wrapper.vulkan.fence;
import sbylib.wrapper.vulkan.swapchain;
import sbylib.wrapper.vulkan.util;

class Queue {

    static struct SubmitInfo {
        @vkProp("pWaitSemaphores", "waitSemaphoreCount") {
            const VkSemaphore[] waitSemaphores;
        }

        @vkProp("pWaitDstStageMask") {
            const VkPipelineStageFlags[] waitDstStageMask;
        }

        @vkProp("pCommandBuffers", "commandBufferCount") {
            const CommandBuffer[] commandBuffers;
        }

        @vkProp("pSignalSemaphores", "signalSemaphoreCount") {
            const VkSemaphore[] pSignalSemaphores;
        }

        const mixin VkTo!(VkSubmitInfo);
    }

    static struct PresentInfo {
        @vkProp("pWaitSemaphores", "waitSemaphoreCount") {
            const VkSemaphore[] waitSemaphores;
        }

        @vkProp("pSwapchains", "swapchainCount") {
            const Swapchain[] swapchains;
        }

        @vkProp("pImageIndices") {
            const uint[] imageIndices;
        }

        @vkProp("pResults") {
            VkResult[] results;
        }

        invariant(swapchains.length == imageIndices.length);
        invariant(results is null || swapchains.length == results.length);

        mixin VkTo!(VkPresentInfoKHR);
    }

    package VkQueue queue;

    this(VkQueue queue) {
        this.queue = queue;
    }

    void submit(uint N)(SubmitInfo[N] _info, Fence _fence) {
        VkFence fence;
        if (_fence)
            fence = _fence.fence;

        VkSubmitInfo[N] info;
        static foreach (i; 0 .. N)
            info[i] = _info[i].vkTo();

        enforceVK(vkQueueSubmit(queue, N, info.ptr, fence));
    }

    void waitIdle() {
        enforceVK(vkQueueWaitIdle(queue));
    }

    void present(PresentInfo _info) {
        auto info = _info.vkTo();
        enforceVK(vkQueuePresentKHR(queue, &info));
    }

    mixin VkTo!(VkQueue);
}
