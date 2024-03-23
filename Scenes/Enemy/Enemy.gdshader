shader_type canvas_item;

uniform float progress = 0.0;

void fragment() {
	vec4 currentColor = texture(TEXTURE, UV);
	if(currentColor.a !=0.0 ) {
		COLOR = currentColor  + (vec4(1.0, 0,0,1) * progress);
	} else {
		COLOR = currentColor;
	}
	// Place fragment code here.
}
