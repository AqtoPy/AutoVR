shader_type canvas_item;

uniform float distortion : hint_range(-0.1, 0.1) = 0.05;

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.x += sin(uv.y * 30.0 + TIME) * distortion;
    uv.y += cos(uv.x * 30.0 + TIME) * distortion;
    
    COLOR = textureLod(SCREEN_TEXTURE, uv, 0.0);
    COLOR.rgb = mix(COLOR.rgb, vec3(0.1), 0.02);
}
