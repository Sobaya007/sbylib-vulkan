#version 400

#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 fragColor;
layout(location = 0) out vec4 color_out;

void main() {
    color_out = vec4(fragColor, 1);
}
