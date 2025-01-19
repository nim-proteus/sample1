#version 330 core

uniform vec3 lightPos;

out vec4 FragColor;
in vec3 Normal;

void main()
{
    FragColor = vec4(1.0f, 1.0f, 0.2f, 1.0f);
} 