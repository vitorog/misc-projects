#version 400
in vec3 vertex_position;
in vec3 vertex_color;
in vec3 tex_coords;

uniform mat4 rotation_matrix;

out vec3 color;
void main(void){
  color = vertex_color;
  gl_Position = rotation_matrix * vec4( vertex_position, 1.0f );
}
