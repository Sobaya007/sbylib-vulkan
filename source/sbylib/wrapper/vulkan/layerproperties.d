module sbylib.wrapper.vulkan.layerproperties;

import erupted;
import sbylib.wrapper.vulkan.physicaldevice;
import sbylib.wrapper.vulkan.util;

struct LayerProperties {
    @vkProp() immutable {
        string layerName;
        uint specVersion;
        uint implementationVersion;
        string description;
    }

    mixin VkFrom!(VkLayerProperties);
    mixin ImplToString;

    static getAvailableInstanceLayerProperties() {
        import std : map, array;
        import erupted : vkEnumerateInstanceLayerProperties;

        uint numLayers;
        vkEnumerateInstanceLayerProperties(&numLayers, null);

        VkLayerProperties[] result = new VkLayerProperties[numLayers];
        vkEnumerateInstanceLayerProperties(&numLayers, result.ptr);

        return result.map!(p => LayerProperties(p)).array;
    }

    static getAvailableDeviceLayerProperties(PhysicalDevice gpu) {
        import std : map, array;
        import erupted : vkEnumerateDeviceLayerProperties;

        uint numLayers;
        vkEnumerateDeviceLayerProperties(gpu.physDevice, &numLayers, null);

        VkLayerProperties[] result = new VkLayerProperties[numLayers];
        vkEnumerateDeviceLayerProperties(gpu.physDevice, &numLayers, result.ptr);

        return result.map!(p => LayerProperties(p)).array;
    }
}
