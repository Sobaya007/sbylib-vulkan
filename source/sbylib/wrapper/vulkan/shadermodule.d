module sbylib.wrapper.vulkan.shadermodule;

import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class ShaderModule {
    static struct CreateInfo {
        @vkProp() {
            immutable VkShaderModuleCreateFlags flags;
        }

        @vkProp("pCode", "codeSize") {
            ubyte[] code;
        }

        mixin VkTo!(VkShaderModuleCreateInfo);
    }

    private Device device;
    package VkShaderModule shaderModule;

    mixin ImplNameSetter!(device, shaderModule, DebugReportObjectType.ShaderModule);

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateShaderModule(device.device, &info, null, &shaderModule));
        enforce(shaderModule != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroyShaderModule(device.device, shaderModule, null);
    }

    mixin VkTo!(VkShaderModule);
}
