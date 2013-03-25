#version 400
in vec3 vertex_position;
in vec3 vertex_color;
in vec3 vertex_tex_coords;

uniform mat4 rotation_matrix;

out vec3 color;
out vec2 tex_coords;

void main(void){
  color = vertex_color;
  tex_coords = vertex_tex_coords;
  gl_Position = rotation_matrix * vec4( vertex_position, 1.0f );
}
