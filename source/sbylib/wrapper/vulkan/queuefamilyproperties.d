module sbylib.wrapper.vulkan.queuefamilyproperties;

import std;
import erupted;
import sbylib.wrapper.vulkan.util;

struct QueueFamilyProperties {

    @vkProp() {
        BitFlags!Flags queueFlags;
        uint queueCount;
        uint timestampValidBits;
        VkExtent3D minImageTransferGranularity;
    }

    enum Flags {
        Graphics = VK_QUEUE_GRAPHICS_BIT,
        Compute = VK_QUEUE_COMPUTE_BIT,
        Transfer = VK_QUEUE_TRANSFER_BIT,
        SparseBinding = VK_QUEUE_SPARSE_BINDING_BIT,
        Protected = VK_QUEUE_PROTECTED_BIT,
    }

    mixin VkFrom!(VkQueueFamilyProperties);
    mixin ImplToString;

    bool supports(Flags flag) const {
        return cast(bool)(queueFlags & flag);
    }
}
