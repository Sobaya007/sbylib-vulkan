module sbylib.wrapper.vulkan.surfaceformat;

import std;
import erupted;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.util;

struct SurfaceFormat {
    @vkProp() {
        VkFormat format;
        VkColorSpaceKHR colorSpace;
    }

    mixin VkFrom!(VkSurfaceFormatKHR);
    mixin ImplToString;
}
