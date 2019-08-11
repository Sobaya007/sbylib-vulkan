#version 450

layout(location = 0) in vec2 pos;
layout(location = 1) in vec3 color;
layout(location = 2) in vec2 uv;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 outUV;

void main() {
    gl_Position = vec4(pos, 0.0, 1.0);
    fragColor = color;
    outUV = uv;
}
