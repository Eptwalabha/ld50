shader_type canvas_item;

void fragment() {
	vec4 c = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb = vec3(1. - c.r, 1. - c.g, 1. - c.b);
}