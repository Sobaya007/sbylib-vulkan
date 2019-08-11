#version 450

#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 fragColor;
layout(location = 0) out vec4 color_out;

layout(binding = 0) uniform UniformData {
    float time;
} uniformData;

void main() {
    color_out = vec4(0.5 + (fragColor - 0.5) * (0.5 + sin(uniformData.time)*0.5), 1);
}
