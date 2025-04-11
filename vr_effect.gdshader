shader_type canvas_item;

// Настройки эффектов
uniform float distortion_intensity : hint_range(0.0, 0.1) = 0.02;
uniform float chromatic_aberration : hint_range(0.0, 0.05) = 0.01;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.7;
uniform float scanlines_opacity : hint_range(0.0, 0.5) = 0.15;
uniform vec4 vignette_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);

// Текстуры эффектов
uniform sampler2D distortion_noise : hint_black;
uniform sampler2D lens_texture : hint_black;

void fragment() {
    // Базовые координаты UV
    vec2 uv = SCREEN_UV;
    
    // Искажение (более сложный алгоритм)
    vec2 distortion = texture(distortion_noise, uv * 0.5 + TIME * 0.1).rg;
    uv += (distortion - 0.5) * distortion_intensity * sin(TIME) * 0.3;
    
    // Хроматическая аберрация
    vec3 color;
    color.r = texture(SCREEN_TEXTURE, vec2(uv.x + chromatic_aberration, uv.y)).r;
    color.g = texture(SCREEN_TEXTURE, uv).g;
    color.b = texture(SCREEN_TEXTURE, vec2(uv.x - chromatic_aberration, uv.y)).b;
    
    // Виньетирование
    vec2 center = vec2(0.5, 0.5);
    float vignette = 1.0 - distance(uv, center) * vignette_strength;
    vignette = pow(vignette, 2.0);
    color *= vignette;
    
    // Эффект линзы (физическая модель)
    vec2 lens_uv = (uv - 0.5) * 2.0;
    float lens_distortion = 1.0 - dot(lens_uv, lens_uv) * 0.3;
    uv = lens_uv * lens_distortion + 0.5;
    
    // Сканирующие линии (имитация дисплея)
    float scanlines = sin(uv.y * SCREEN_PIXEL_SIZE.y * 1000.0 + TIME * 2.0) * 0.5 + 0.5;
    color *= 1.0 - (scanlines * scanlines_opacity);
    
    // Финал
    COLOR = vec4(color, 1.0);
    
    // Наложение текстуры линзы
    vec4 lens_effect = texture(lens_texture, SCREEN_UV);
    COLOR.rgb = mix(COLOR.rgb, lens_effect.rgb, lens_effect.a * 0.2);
}
