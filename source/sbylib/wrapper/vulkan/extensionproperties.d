module sbylib.wrapper.vulkan.extensionproperties;

import erupted;
import sbylib.wrapper.vulkan.physicaldevice;
import sbylib.wrapper.vulkan.util;

struct ExtensionProperties {
    @vkProp() immutable {
        string extensionName;
        uint specVersion;
    }

    mixin VkFrom!(VkExtensionProperties);
    mixin ImplToString;

    static getAvailableInstanceExtensionProperties(string layerName) {
        import std : map, array, toStringz;
        import erupted : vkEnumerateInstanceExtensionProperties;

        uint numExtensions;
        vkEnumerateInstanceExtensionProperties(layerName.toStringz(), &numExtensions, null);

        VkExtensionProperties[] result = new VkExtensionProperties[numExtensions];
        vkEnumerateInstanceExtensionProperties(layerName.toStringz(), &numExtensions, result.ptr);

        return result.map!(p => ExtensionProperties(p)).array;
    }

    static getAvailableDeviceExtensionProperties(PhysicalDevice gpu, string layerName) {
        import std : map, array, toStringz;
        import erupted : vkEnumerateDeviceExtensionProperties;

        uint numExtensions;
        vkEnumerateDeviceExtensionProperties(gpu.physDevice, layerName.toStringz(), &numExtensions, null);

        VkExtensionProperties[] result = new VkExtensionProperties[numExtensions];
        vkEnumerateDeviceExtensionProperties(gpu.physDevice, layerName.toStringz(), &numExtensions, result.ptr);

        return result.map!(p => ExtensionProperties(p)).array;
    }
}
