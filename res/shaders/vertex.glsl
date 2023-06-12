#version 410 core

layout (location = 0) in vec3 vertexPosition;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 uv;

uniform mat4 mvp;
out vec3 oNormal;
out vec2 oUv;

void main()
{
    gl_Position = mvp * vec4(vertexPosition, 1.0);
    oNormal = normal;
    oUv = uv.xy;
}