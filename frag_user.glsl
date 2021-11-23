#version 330 core

uniform vec3 col;
uniform vec3 vfx;
uniform vec3 col_clear;

in  vec3 pos_frag;
out vec4 final;

void main()
{
	if (vfx.x == 0) {
		final = vec4(col, 1);
		return;
	}

	float light = clamp((pos_frag.y + .5), 0, 1);
	final = vec4(mix(1 - col, col, light), 1);
}
