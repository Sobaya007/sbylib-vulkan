module sbylib.wrapper.vulkan.layerproperties;

import erupted;
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

        uint numInstanceLayers;
        vkEnumerateInstanceLayerProperties(&numInstanceLayers, null);

        VkLayerProperties[] result = new VkLayerProperties[numInstanceLayers];
        vkEnumerateInstanceLayerProperties(&numInstanceLayers, result.ptr);

        return result.map!(p => LayerProperties(p)).array;
    }
}
