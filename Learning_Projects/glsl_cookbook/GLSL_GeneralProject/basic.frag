#version 400
in vec3 color;
in vec2 tex_coords;

layout (location = 0) out vec4 frag_color;

uniform BlobSettings {
  vec4 inner_color;
  vec4 outer_color;
  float radius_inner;
  float radius_outer;
};

void main(void){
  float dx = tex_coords.x - 0.5;
  float dy = tex_coords.y - 0.5;
  float dist = sqrt(dx*dx + dy * dy);

  //frag_color = vec4(color, 1.0f);
  frag_color = mix(inner_color, outer_color, smoothstep( radius_inner, radius_outer, dist) );
  //frag_color = vec4(1.0f, 0.0f, 0.0f, 1.0f);
}
