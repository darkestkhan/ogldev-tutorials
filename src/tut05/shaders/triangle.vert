#version 330

layout (location = 0) in vec3 Position;

uniform float Scale;

void main (void)
{
  gl_Position =
    vec4 (Scale * Position.x, Scale * Position.y, Scale * Position.z, 1.0);
}
