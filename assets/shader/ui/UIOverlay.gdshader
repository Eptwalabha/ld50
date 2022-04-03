shader_type canvas_item;

uniform bool visible = false;
uniform float blink_frequency = 2.0;
uniform float min_alpha : hint_range(.0, 1.) =.5;
uniform float border_width = 100.0;
uniform float border_fuzz = 20.0;
uniform vec4 border_color : hint_color = vec4(.0);
uniform vec4 inner_color : hint_color = vec4(.0);

uniform vec2 size = vec2(.0);

float border_strength(float ux, float uy) {
	float x = size.x * ux;
	float y = size.y * uy;
	float x2 = smoothstep(border_width + border_fuzz, border_width, x) +
		smoothstep(size.x - (border_width + border_fuzz), size.x - border_width, x);
	float y2 = smoothstep(border_width + border_fuzz, border_width, y) +
		smoothstep(size.y - (border_width + border_fuzz), size.y - border_width, y);
	return max(x2, y2);
}

void fragment() {
	if (visible) {
		float ratio = border_strength(UV.x, UV.y);
		COLOR = mix(inner_color, border_color, ratio);
		COLOR.a *= sin(TIME * blink_frequency * 4.) * .5 * (1. - min_alpha) + min_alpha / 2.0 + .5;
	} else {
		COLOR.a = 0.;
	}
}