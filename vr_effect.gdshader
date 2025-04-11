shader_type canvas_item;

// Основные настройки
uniform float distortion_strength = 0.02;
uniform float noise_intensity = 0.15;
uniform float chromatic_aberration = 0.005;
uniform float vignette_power = 1.5;
uniform float scanline_speed = 2.0;
uniform float dynamic_range = 2.0;

// Текстуры эффектов
uniform sampler2D noise_texture;
uniform sampler2D lens_dirt_texture;
uniform sampler2D static_noise_texture;

// Эффект дрожания камеры
uniform vec2 camera_jitter = vec2(0.0);
uniform float jitter_speed = 0.5;

// Ночное видение
uniform bool night_vision = false;
uniform vec3 nv_color = vec3(0.2, 0.8, 0.2);
uniform float nv_gain = 2.5;

// Эффекты датчика
uniform float exposure_compensation = 1.0;
uniform float focus_breathing = 0.02;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    // Базовые координаты
    vec2 uv = SCREEN_UV;
    
    // Динамическое дрожание
    vec2 jitter = vec2(
        sin(TIME * 10.0) * 0.0005 * jitter_speed,
        cos(TIME * 8.0) * 0.0007 * jitter_speed
    );
    uv += jitter;
    
    // Хроматическая аберрация с шумом
    vec3 color;
    vec2 noise = texture(noise_texture, uv * 2.0 + TIME * 0.1).rg;
    color.r = texture(SCREEN_TEXTURE, uv + vec2(chromatic_aberration + noise.x * 0.002, 0.0)).r;
    color.g = texture(SCREEN_TEXTURE, uv).g;
    color.b = texture(SCREEN_TEXTURE, uv - vec2(chromatic_aberration + noise.y * 0.002, 0.0)).b;
    
    // Эффект CMOS-сенсора
    vec2 sensor_uv = uv * 1.2 - 0.1;
    float sensor_noise = texture(static_noise_texture, sensor_uv + TIME * 0.05).r;
    color *= 1.0 - sensor_noise * noise_intensity;
    
    // Виньетирование с анаморфными бликами
    vec2 vignette_uv = (uv - 0.5) * 2.0;
    float vignette = 1.0 - pow(length(vignette_uv), vignette_power);
    vignette *= 1.0 - smoothstep(0.7, 1.0, length(vignette_uv));
    
    // Эффект грязной линзы
    vec4 lens_dirt = texture(lens_dirt_texture, uv * 0.8 + jitter * 5.0);
    color = mix(color, lens_dirt.rgb, lens_dirt.a * 0.3);
    
    // Сканирующие линии (имитация CMOS-сканирования)
    float scanline = sin(uv.y * SCREEN_PIXEL_SIZE.y * 1500.0 + TIME * scanline_speed);
    color *= 1.0 - (0.3 * abs(scanline));
    
    // Динамический диапазон и экспозиция
    color = pow(color * exposure_compensation, vec3(dynamic_range));
    
    // Эффект фокусировки
    float focus_noise = texture(noise_texture, uv * 0.5 + TIME * 0.2).g;
    color = mix(color, color * focus_noise, focus_breathing);
    
    // Ночное видение
    if(night_vision) {
        float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
        color = nv_color * luminance * nv_gain;
        color += sensor_noise * 0.1;
    }
    
    // Финальное смешивание
    COLOR = vec4(color * vignette, 1.0);
    
    // Эффект цифрового сжатия
    float compression = floor(texture(static_noise_texture, uv * 0.5).r * 8.0) / 8.0;
    COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * compression, 0.1);
}
