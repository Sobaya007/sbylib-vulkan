module sbylib.wrapper.vulkan.commandpool;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.util;

class CommandPool {
    static struct CreateInfo {
        @vkProp("flags") {
            immutable BitFlags!(Flags) flags;
        }
        @vkProp() {
            immutable uint queueFamilyIndex;
        }

        enum Flags {
            Transient = VK_COMMAND_POOL_CREATE_TRANSIENT_BIT,
            ResetCommandBuffer = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
            Protected = VK_COMMAND_POOL_CREATE_PROTECTED_BIT,
        }

        const mixin VkTo!(VkCommandPoolCreateInfo);
    }

    private Device device;
    package VkCommandPool commandPool;

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateCommandPool(device.device, &info, null, &commandPool));
        enforce(commandPool != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyCommandPool(device.device, commandPool, null);
    }

    mixin VkTo!(VkCommandPool);
}
