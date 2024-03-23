shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform int pixelSize: hint_range(2, 16, 2) = 2;

void fragment() {
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;
	float pixelX = 1.0 / res.x;
	float pixelY = 1.0 / res.y;
	
	float cellX = float(pixelSize) * pixelX;
	float cellY = float(pixelSize) * pixelY;
	
	float x = cellX * floor(UV.x / cellX);
	float y = cellX * floor(UV.y / cellY);
	
	COLOR = texture(TEXTURE, vec2(x,y));
	// Place fragment code here.
}
