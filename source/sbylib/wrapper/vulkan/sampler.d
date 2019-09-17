module sbylib.wrapper.vulkan.sampler;

import std;
import erupted;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

class Sampler {
    static struct CreateInfo {

        @vkProp() {
            VkSamplerCreateFlags flags;
            SamplerFilter magFilter;
            SamplerFilter minFilter;
            SamplerMipmapMode mipmapMode;
            SamplerAddressMode addressModeU;
            SamplerAddressMode addressModeV;
            SamplerAddressMode addressModeW;
            float mipLodBias;
            bool anisotropyEnable;
            float maxAnisotropy;
            bool compareEnable;
            CompareOp compareOp;
            float minLod;
            float maxLod;
            BorderColor borderColor;
            bool unnormalizedCoordinates;
        }

        const mixin VkTo!(VkSamplerCreateInfo);
    }

    private Device device;
    package VkSampler sampler;

    mixin ImplNameSetter!(device, sampler, DebugReportObjectType.Sampler);

    this(Device device, CreateInfo _info) {
        import std.exception : enforce;

        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkCreateSampler(device.device, &info, null, &sampler));
        enforce(sampler != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroySampler(device.device, sampler, null);
    }

    mixin VkTo!(VkSampler);
}
