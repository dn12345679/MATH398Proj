shader_type canvas_item;

uniform float pixelation_amount : hint_range(1.0, 100.0) = 1.0;


void fragment() {
    vec2 texture_size = 1.0 / TEXTURE_PIXEL_SIZE;

    vec2 pixel_size = vec2(pixelation_amount) / texture_size;

    vec2 pixelated_uv = floor(UV / pixel_size) * pixel_size;

    COLOR = texture(TEXTURE, pixelated_uv);
}