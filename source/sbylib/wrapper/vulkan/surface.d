module sbylib.wrapper.vulkan.surface;

import erupted;
import sbylib.wrapper.glfw;
import sbylib.wrapper.vulkan.instance;
import sbylib.wrapper.vulkan.util;

class Surface {

    private Instance instance;
    package VkSurfaceKHR surface;

    this(Window window, ref Instance instance) {
        import std.exception : enforce;

        this.instance = instance;

        enforceVK(window.createWindowSurface(instance.instance, null, &surface));
        enforce(surface != VK_NULL_HANDLE);
    }

    ~this() {
        vkDestroySurfaceKHR(instance.instance, surface, null);
    }

    mixin VkTo!(VkSurfaceKHR);
}

Surface createSurface(Window window, ref Instance instance) {
    return new Surface(window, instance);
}
