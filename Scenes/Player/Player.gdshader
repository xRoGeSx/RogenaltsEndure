shader_type canvas_item;
uniform sampler2D noise : repeat_enable;
void fragment() {
	vec4 noisePixel = texture(noise, UV * TIME * vec2(0.05,0.12));
	vec4 pixel = texture(TEXTURE, UV);
	if(pixel.a != 0.0) {
		COLOR = COLOR * vec4(1, 0,0,1) * noisePixel;
		
	} else {
		
	}
	// Place fragment code here.
}
