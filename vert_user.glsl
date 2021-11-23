#version 330 core

#define QUANT 1024

uniform mat4 vp;
uniform mat4 trs;

in  vec3 pos;
out vec3 pos_frag;

void main()
{
	vec4 result = trs * vec4(pos, 1);
	result = floor(result * QUANT) / QUANT;
	pos_frag = result.xyz;
	gl_Position = vp * result;
}
