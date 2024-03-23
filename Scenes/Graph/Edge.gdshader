shader_type canvas_item;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if(UV.x > 0.0) {
		pixel = vec4(1.0, 0,0,1.0);
	}
	COLOR = pixel;
	// Place fragment code here.
}
