module sbylib.wrapper.vulkan.fence;

import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.util;

class Fence {
    static struct CreateInfo {
        @vkProp() {
            immutable VkFenceCreateFlags flags;
        }

        const mixin VkTo!(VkFenceCreateInfo);
    }

    private Device device;
    package VkFence fence;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateFence(device.device, &info, null, &fence));
        enforce(fence != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyFence(device.device, fence, null);
    }

    static void wait(uint N)(Fence[N] _fences, bool waitAll, ulong timeout) {
        VkFence[N] fences;
        static foreach (i; 0 .. N)
            fences[i] = _fences[i].fence;
        enforceVK(vkWaitForFences(_fences[0].device.device, N, fences.ptr, waitAll, timeout));
    }

    static void reset(uint N)(Fence[N] _fences) {
        VkFence[N] fences;
        static foreach (i; 0 .. N)
            fences[i] = _fences[i].fence;
        enforceVK(vkResetFences(_fences[0].device.device, N, fences.ptr));
    }

    static void wait(Fence[] _fences, bool waitAll, ulong timeout) {
        VkFence[256] fences;
        foreach (i; 0.._fences.length)
            fences[i] = _fences[i].fence;
        enforceVK(vkWaitForFences(_fences[0].device.device, cast(uint)_fences.length, fences.ptr, waitAll, timeout));
    }

    static void reset(Fence[] _fences) {
        VkFence[256] fences;
        foreach (i; 0.._fences.length)
            fences[i] = _fences[i].fence;
        enforceVK(vkResetFences(_fences[0].device.device, cast(uint)_fences.length, fences.ptr));
    }
}
