shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform sampler2D noise_2 : repeat_enable;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform vec2 scroll = vec2(.05, 0.5);
uniform vec2 scroll_2 = vec2(.05, 0.5);
uniform float distortion : hint_range(-1, 1)  = 0.3;
uniform vec4 tone : source_color;
uniform vec4 top_tone: source_color;
uniform float light_start : hint_range(0.0, 1.0)  = 0.275;
uniform float light_end : hint_range(0.0, 1.0)  = 0.4;

void fragment() {
	float d =
	  texture(noise, UV + scroll * TIME).r 
	* texture(noise_2, UV +scroll_2 * TIME).r;
	vec4 screen_color =texture(SCREEN_TEXTURE, SCREEN_UV + distortion * vec2(d));
	vec4 top_light = smoothstep(light_start, light_end, d) * top_tone;
	COLOR = screen_color * tone + top_light;
	COLOR.a = 1.0;
	
	// Place fragment code here.
}
