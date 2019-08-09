module sbylib.wrapper.vulkan.devicememory;

import erupted;
import sbylib.wrapper.vulkan.buffer;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.util;

class DeviceMemory {
    static struct AllocateInfo {
        @vkProp() {
            VkDeviceSize allocationSize;
            uint32_t memoryTypeIndex;
        }

        const mixin VkTo!(VkMemoryAllocateInfo);
    }

    private Device device;
    private VkDeviceMemory deviceMemory;

    this(Device device, AllocateInfo _info) {
        this.device = device;

        auto info = _info.vkTo();

        enforceVK(vkAllocateMemory(device.device, &info, null, &deviceMemory));
    }

    ~this() {
        vkFreeMemory(device.device, deviceMemory, null);
    }

    ubyte[] map(VkDeviceSize offset, VkDeviceSize size, VkMemoryMapFlags flags) {
        ubyte* pData;
        enforceVK(vkMapMemory(device.device, deviceMemory, offset, size, flags,
                cast(void**)(&pData)));
        return pData[0 .. size];
    }

    void unmap() {
        vkUnmapMemory(device.device, deviceMemory);
    }

    void bindBuffer(Buffer buffer, VkDeviceSize memoryOffset) {
        enforceVK(vkBindBufferMemory(device.device, buffer.buffer, deviceMemory, memoryOffset));
    }
}
