module sbylib.wrapper.vulkan.instance;

import std;
import erupted;
import sbylib.wrapper.vulkan.physicaldevice;
import sbylib.wrapper.vulkan.util;

class Instance {
    static struct ApplicationInfo {
        @vkProp() immutable {
            uint applicationVersion;
            uint engineVersion;
            uint apiVersion;
        }

        @vkProp("pApplicationName") {
            string applicationName;
        }

        @vkProp("pEngineName") {
            string engineName;
        }

        const mixin VkTo!(VkApplicationInfo);
    }

    static struct CreateInfo {
        @vkProp() {
            immutable VkInstanceCreateFlags flags;
        }

        @vkProp("pApplicationInfo") {
            const ApplicationInfo applicationInfo;
        }

        @vkProp("ppEnabledLayerNames", "enabledLayerCount") {
            const string[] enabledLayerNames;
        }

        @vkProp("ppEnabledExtensionNames", "enabledExtensionCount") {
            const string[] enabledExtensionNames;
        }

        const mixin VkTo!(VkInstanceCreateInfo);
    }

    package VkInstance instance;

    this(CreateInfo info) {
        auto vkInfo = info.vkTo();
        enforceVK(vkCreateInstance(&vkInfo, null, &instance));
        enforce(instance != VK_NULL_HANDLE);

        loadInstanceLevelFunctions(instance);
    }

    ~this() {
        vkDestroyInstance(instance, null);
    }

    auto enumeratePhysicalDevices() {
        import std : map, array;

        uint numPhysDevices;
        enforceVK(vkEnumeratePhysicalDevices(instance, &numPhysDevices, null));

        auto physDevices = new VkPhysicalDevice[](numPhysDevices);
        enforceVK(vkEnumeratePhysicalDevices(instance, &numPhysDevices, physDevices.ptr));
        assert(physDevices.length == numPhysDevices);

        return physDevices.map!(dev => new PhysicalDevice(dev)).array;
    }

    PhysicalDevice findPhysicalDevice(alias pred)() {
        import std : countUntil, enforce;

        auto physDevices = this.enumeratePhysicalDevices();
        const gpuIndex = physDevices.countUntil!(pred);
        enforce(gpuIndex != -1, "There are no GPUs with Surface support.");
        return physDevices[gpuIndex];
    }
}
