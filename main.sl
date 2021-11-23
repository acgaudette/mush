#include "rubbish/bin.h"
#include "rubbish/mesh.h"

static int spin = 1;

static enum {
	   STATE_QUAD
	,  STATE_BILL
	,  STATE_CUBE
	,  STATE_ICO
	, _STATE_N
} state;

static void init()
{
}

static void update()
{
	render.col = $ .1 .1 .1

	if (key_press(GLFW_KEY_ENTER) | btn_press(GLFW_MOUSE_BUTTON_1))
		state = (state + 1) % _STATE_N;
	if (btn_press(GLFW_MOUSE_BUTTON_3))
		spin = !spin;

	mesh_vfx = $ 1 0 0
	mesh_col = $ .9 .5 .3
	mesh_wire = key_held(GLFW_KEY_SPACE) | btn_held(GLFW_MOUSE_BUTTON_2);

	switch (state) {
	case STATE_QUAD:
		mesh_quad(
			(quad) {
				$ 0 0 0 ,
				$ 0 1 0 ,
				$ 1 1 0 ,
				$ 1 0 0 ,
			}
		);
		break;
	case STATE_BILL:
		mesh_bill(
			(bill) {
				.anc = $ 0 0 ,
				.ext = $ 2 1 ,
				.rot = QT_ID,
			}
		);
		break;
	case STATE_CUBE:
		mesh_cuboid(
			(cuboid) {
				.ext = V3_ONE,
				.anc = $ 0 0 0 ,
			}
		);
		break;
	case STATE_ICO:
		mesh_ico(
			(ico) {
				.scale = 1.f,
			}
		);
		break;
	default:
		break;
	}

	lines_push(V3_ZERO, V3_RT,  V3_RT);
	lines_push(V3_ZERO, V3_UP,  V3_UP);
	lines_push(V3_ZERO, V3_FWD, V3_FWD);

	{
		static float roll;
		roll += $ * .01 mouse.delta.x

		const float angle = spin ? $ t : roll'
		const ff dir = $ sin * .5 angle cos * .5 angle
		v3 dir3 = v3_padxz(dir, 0.f);
		cam.pos = $ * dir3'3 ~ 4

		static float height = 1.f;
		height = $ clamp + height' * .01 mouse.delta.y ~ 4 4
		cam.pos.y = height;

		dir3 = $ norm ~ cam.pos'3
		cam.rot = qt_vecs_fwd(dir3, V3_UP);

		cam.fov = 45.f;
		cam.near = 1.f;
		cam.far = 16.f;
	}
}

#include "vert.h"
#include "frag.h"
int main()
{
	rubbish_cfg cfg = {
		.flags = RUBBISH_CFG_AA,
		.line_width = 2.f,
		.vert = {
			.n = vert_user_glsl_len,
			.raw = (char*)vert_user_glsl,
		},
		.frag = {
			.n = frag_user_glsl_len,
			.raw = (char*)frag_user_glsl,
		},
	};

	rubbish_run(cfg, init, update, NULL);
}
