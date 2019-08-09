module sbylib.wrapper.vulkan.surfacecapabilities;

import std;
import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

struct SurfaceCapabilities {
    @vkProp() {
        uint minImageCount;
        uint maxImageCount;
        VkExtent2D currentExtent;
        VkExtent2D minImageExtent;
        VkExtent2D maxImageExtent;
        uint maxImageArrayLayers;
        BitFlags!SurfaceTransform supportedTransforms;
        SurfaceTransform currentTransform;
        BitFlags!CompositeAlpha supportedCompositeAlpha;
        BitFlags!ImageUsage supportedUsageFlags;
    }

    mixin VkFrom!(VkSurfaceCapabilitiesKHR);
    mixin ImplToString;

    bool supports(SurfaceTransform transform) const {
        return cast(bool)(supportedTransforms & transform);
    }

    bool supports(CompositeAlpha compositeAlpha) const {
        return cast(bool)(supportedCompositeAlpha & compositeAlpha);
    }

    bool supports(ImageUsage usage) const {
        return cast(bool)(supportedUsageFlags & usage);
    }
}
