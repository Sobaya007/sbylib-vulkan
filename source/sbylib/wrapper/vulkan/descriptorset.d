module sbylib.wrapper.vulkan.descriptorset;

import std;
import erupted;
import sbylib.wrapper.vulkan.buffer;
import sbylib.wrapper.vulkan.descriptorpool;
import sbylib.wrapper.vulkan.descriptorsetlayout;
import sbylib.wrapper.vulkan.device;
import sbylib.wrapper.vulkan.enums;
import sbylib.wrapper.vulkan.imageview;
import sbylib.wrapper.vulkan.sampler;
import sbylib.wrapper.vulkan.util;

class DescriptorSet {
    static struct AllocateInfo {
        @vkProp() {
            DescriptorPool descriptorPool;
        }

        @vkProp("pSetLayouts", "descriptorSetCount") {
            const DescriptorSetLayout[] setLayouts;
        }

        mixin VkTo!(VkDescriptorSetAllocateInfo);
    }

    static struct Write {
        static struct ImageInfo {
            @vkProp() {
                Sampler sampler;
                ImageView imageView;
                ImageLayout imageLayout;
            }
            mixin VkTo!(VkDescriptorImageInfo);
        }

        static struct BufferInfo {
            @vkProp() {
                Buffer buffer;
                VkDeviceSize offset;
                VkDeviceSize range;
            }
            mixin VkTo!(VkDescriptorBufferInfo);
        }

        @vkProp() {
            DescriptorSet dstSet;
            uint dstBinding;
            uint dstArrayElement;
            DescriptorType descriptorType;
        }

        @vkProp("pImageInfo", "descriptorCount") {
            ImageInfo[] imageInfo;
        }

        @vkProp("pBufferInfo", "descriptorCount") {
            BufferInfo[] bufferInfo;
        }

        @vkProp("pTexelBufferView", "descriptorCount") {
            VkBufferView[] texelBufferView;
        }

        mixin VkTo!(VkWriteDescriptorSet);
    }

    static struct Copy {
        @vkProp() {
            DescriptorSet srcSet;
            uint srcBinding;
            uint srcArrayElement;
            DescriptorSet dstSet;
            uint dstBinding;
            uint dstArrayElement;
            uint descriptorCount;
        }

        mixin VkTo!(VkCopyDescriptorSet);
    }

    private Device device;
    private DescriptorPool descriptorPool;
    private VkDescriptorSet descriptorSet;

    private this(Device device, DescriptorPool descriptorPool, VkDescriptorSet descriptorSet) {
        import std.exception : enforce;

        this.device = device;
        this.descriptorPool = descriptorPool;
        this.descriptorSet = descriptorSet;
    }

    mixin VkTo!(VkDescriptorSet);

    static DescriptorSet[] allocate(Device device, AllocateInfo _info) {
        VkDescriptorSet[] descriptorSets = new VkDescriptorSet[_info.setLayouts.length];

        auto info = _info.vkTo();

        enforceVK(vkAllocateDescriptorSets(device.device, &info, descriptorSets.ptr));

        return descriptorSets.map!(cb => new DescriptorSet(device, _info.descriptorPool, cb)).array;
    }

    void update(uint W, uint C)(Write[W] _writes, Copy[C] _copies) {
        VkWriteDescriptorSet[W] writes;
        static foreach (i; 0..W) {
            writes[i] = _writes[i].vkTo();
        }

        VkCopyDescriptorSet[C] copies;
        static foreach (i; 0..C) {
            copies[i] = _copies[i].vkTo();
        }
        vkUpdateDescriptorSets(device.device, W, writes.ptr, C, copies.ptr);
    }
}
