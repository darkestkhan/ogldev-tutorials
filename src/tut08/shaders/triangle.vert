#version 330

layout (location = 0) in vec3 Position;

uniform mat4 World;

void main (void)
{
  gl_Position = World * vec4 (Position, 1.0);
}
