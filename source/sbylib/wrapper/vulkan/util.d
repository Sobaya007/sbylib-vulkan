module sbylib.wrapper.vulkan.util;

import std;
import erupted;
import sbylib.wrapper.vulkan;

struct VkProp {
    string[] names;
}

VkProp vkProp(string[] names...) {
    return VkProp(names);
}

// ex) uint -> uint
Dst convFrom(Dst)(Dst t) if (isBasicType!Dst) {
    return t;
}

// ex) VkMemoryType -> VkMemoryType
Dst convFrom(Dst)(Dst t) if (is(Dst == struct)) {
    return t;
}

// ex) char[256] -> immutable(string)
Dst convFrom(Dst: string, uint N)(char[N] src) {
    return fromStringz(src.ptr).idup;
}

// ex) uint -> BitFlags!Flags
Dst convFrom(Dst, Src)(Src src) if (isInstanceOf!(BitFlags, Dst)) {
    Dst result;
    static if (is(Dst == BitFlags!Enum, Enum)) {
        static foreach (mem; EnumMembers!Enum) {
            if (src & mem) {
                result |= mem;
            }
        }
    } else {
        static assert(false);
    }
    return result;
}

// ex) (VkMemoryType[32], uint) -> const(VkMemoryType)[]
Dst construct(Dst, Src, uint N, Length)(Src[N] src, Length len) if (isDynamicArray!(Dst))
    in (len < N)
{
    alias DstE = Unqual!(ForeachType!(Dst));

    DstE[] result = new DstE[len];
    foreach (i; 0..len) {
        result[i] = convFrom!DstE(src[i]);
    }
    return result;
}

// ex) VkMemoryHeap -> MemoryHeap
Dst convFrom(Dst, Src)(Src src) if (is(Src == struct) && is(Dst == struct) && !is(Src == Dst)) {
    return Dst(src);
}

// ex) VkSurfaceTransformFlagBitsKHR -> SurfaceTransform
Dst convFrom(Dst, Src)(Src src) if (is(Src == enum) && is(Dst == enum) && !is(Src == Dst)) {
    return src.to!(OriginalType!Src).to!(Dst);
}

// ex) uint -> uint
Dst convTo(Dst)(Dst t) if (isBasicType!Dst) {
    return t;
}

// ex) VkRect2D -> VkRect2D
Dst convTo(Dst)(Dst t) if (is(Dst == struct)) {
    return t;
}

// ex) VkClearValue -> VkClearValue
Dst convTo(Dst)(Dst t) if (is(Dst == union)) {
    return t;
}

// ex) const(VkPhysicalDeviceFeatures)* -> const(VkPhysicalDeviceFeatures*)
Dst convTo(Dst)(Dst t) if (isPointer!Dst) {
    return t;
}

// ex) immutable(float[4]) -> float[4]
Dst convTo(Dst)(Dst t) if (isStaticArray!Dst) {
    return t;
}

// ex) CommandPool -> VkCommandPool
Dst convTo(Dst, Src)(Src src) if (is(Src == class) && hasMember!(Src, "vkTo") && isPointer!(Dst)) {
    if (src is null) return null;

    return src.vkTo();
}


// ex) CommandBuffer.InheritanceInfo -> VkCommandBufferInheritanceInfo
Dst convTo(Dst, Src)(Src src) if (is(Src == struct) && is(Dst == struct) && hasMember!(Src, "vkTo")) {
    return src.vkTo();
}

// ex) CommandBuffer.InheritanceInfo -> const(VkCommandBufferInheritanceInfo)*
Dst convTo(Dst, Src)(Src src) if (is(Src == struct) && isPointer!(Dst)) {
    alias DstE = Unqual!(PointerTarget!Dst);

    DstE* tmp = new DstE;
    *tmp = convTo!(DstE)(src);
    return tmp;
}

// ex) immutable BitFlags!(Flags) -> uint
Dst convTo(Dst, Src)(Src src) if (isInstanceOf!(BitFlags, Src)) {
    static if (is(Src == BitFlags!Enum, Enum)) {
        return to!Dst(cast(OriginalType!Enum)src);
    } else {
        static assert(false);
    }
}

// ex) const(string) -> const(char)*
Dst convTo(Dst)(const string src) {
    return src.toStringz();
}

// ex) const(uint[]) -> (uint*, uint)
Tuple!(Dst*, Length) destruct(Dst, Length, Src)(Src[] src) if (is(Src == Dst)) {
    return tuple(src.ptr, cast(Length) src.length);
}

// ex) const(QueueCreateInfo[]) -> (VkDeviceQueueCreateInfo*, uint)
Tuple!(Dst*, Length) destruct(Dst, Length, Src)(const Src[] src)
    if (!is(Src == Dst) && !isBasicType!Src && !isBasicType!Dst)
{
    Dst[] dst = new Dst[src.length];
    foreach (i; 0 .. src.length) {
        dst[i] = convTo!(Dst)(src[i]);
    }
    return tuple(dst.ptr, cast(Length) dst.length);
}

// ex) ShaderStageCreateInfo -> (VkPipelineShaderStageCreateInfo, uint)
Tuple!(Dst*, Length) destruct(Dst, Length, Src)(Src[] src)
    if (!is(Src == Dst) && !isBasicType!Src && !isBasicType!Dst)
{
    Dst[] dst = new Dst[src.length];
    foreach (i; 0 .. src.length) {
        dst[i] = convTo!(Dst)(src[i]);
    }
    return tuple(dst.ptr, cast(Length) dst.length);
}

// ex) ubyte[] -> (uint*, size_t)
Tuple!(Dst*, Length) destruct(Dst, Length, Src)(Src[] src)
    if (!is(Src == Dst) && isBasicType!Src && isBasicType!Dst)
{
    return tuple(cast(Dst*)src.ptr, cast(Length) src.length);
}

mixin template VkFrom(OriginalType) {
    import std;
    import sbylib.wrapper.vulkan.util;

    this(OriginalType orig) {
        static foreach (name; VkPropertyNames!(typeof(this))) {
            {
                alias Dst = Unqual!(typeof(mixin("this.", name)));
                alias props = getUDAs!(mixin("this.", name), VkProp);
                static assert(props.length == 1);
                enum names = props[0].names;

                static if (names.length > 0) {
                    auto tmp = mixin("tuple(", names.map!(n => "orig." ~ n).join(","), ")");
                    mixin("this.", name) = construct!(Dst)(tmp.expand);
                } else {
                    mixin("this.", name) = convFrom!(Dst)(mixin("orig.", name));
                }
            }
        }
    }
}

mixin template VkTo(OriginalType) {
    import std;
    import sbylib.wrapper.vulkan.util;

    template hasOriginalType(string[] members) {
        static if (members.length == 0)
            enum hasOriginalType = false;
        else static if (is(typeof(__traits(getMember, typeof(this), members[0])) == OriginalType))
            enum hasOriginalType = true;
        else
            enum hasOriginalType = hasOriginalType!(members[1 .. $]);
    }

    static if (hasOriginalType!([__traits(allMembers, typeof(this))])) {
        inout(OriginalType) vkTo() inout {
            static foreach (mem; FieldNameTuple!(typeof(this))) {
                static if (is(typeof(mixin("this.", mem)) == inout(OriginalType))) {
                    return mixin("this.", mem);
                }
            }
        }
    } else {
        OriginalType vkTo() {
            OriginalType orig;
            static foreach (name; VkPropertyNames!(typeof(this))) {
                {
                    alias Src = typeof(mixin("this.", name));

                    alias props = getUDAs!(mixin("this.", name), VkProp);
                    static assert(props.length == 1);

                    enum names = props[0].names;

                    static if (names.length == 2) {
                        static assert(isArray!(Src));

                        alias DstPtr = typeof(mixin("orig.", names[0]));
                        alias Length = typeof(mixin("orig.", names[1]));

                        static assert(isPointer!(DstPtr));
                        alias Dst = Unqual!(PointerTarget!(DstPtr));

                        auto tmp = destruct!(Dst, Length)(mixin("this.", name));
                        mixin("orig.", names[0]) = tmp[0];

                        if (tmp[1] > 0 && mixin("orig.", names[1]) == 0) {
                            mixin("orig.", names[1]) = tmp[1]; // for avoiding double assignment
                        }
                    } else static if (names.length == 1) {
                        alias Dst = typeof(mixin("orig.", names[0]));
                        static if (isDynamicArray!(Src) && isPointer!(Dst)) {
                            auto tmp = destruct!(Unqual!(PointerTarget!Dst), uint)(mixin("this.", name));
                            mixin("orig.", names[0]) = tmp[0];
                        } else {
                            mixin("orig.", names[0]) = convTo!(Dst)(mixin("this.", name));
                        }
                    } else static if (names.length == 0) {
                        alias Dst = typeof(mixin("orig.", name));
                        mixin("orig.", name) = convTo!(Dst)(mixin("this.", name));
                    } else {
                        static assert(false);
                    }
                }
            }
            return orig;
        }
    }
}

mixin template ImplToString() {
    import std;
    import std : format;

    string toString() const {

        enum names = VkPropertyNames!(typeof(this));

        enum L = names.map!(n => n.length).maxElement;

        string[] fields;
        static foreach (name; names) {
            {
                static if (is(Unqual!(typeof(mixin("this.", name))) == BitFlags!E, E)) {
                    fields ~= format!("%" ~ L.to!string ~ "s: %s")(name,
                            [EnumMembers!E].filter!(m => cast(bool)(mixin("this.", name) & m))
                            .map!(to!string)
                            .join(" | "));
                } else {
                    fields ~= format!("%" ~ L.to!string ~ "s: %s")(name,
                            mixin("this.", name).to!string);
                }
            }
        }

        return format!"%s {\n%s\n}"(Unqual!(typeof(this)).stringof,
                fields.map!(txt => "  " ~ txt).join("\n"));
    }
}

template VkPropertyNames(This) {
    import std;

    private enum isVkProp(string name) = hasUDA!(__traits(getMember, This, name), VkProp);
    static immutable VkPropertyNames = [
        Filter!(isVkProp, FieldNameTuple!(This))
    ];
}

void enforceVK(VkResult res) {
    enforce(res == VkResult.VK_SUCCESS, res.to!string);
}

void compileShader(string filename) {
    const result = executeShell("glslangValidator -e main -V " ~ filename);
    assert(result.status == 0, result.output);
}
