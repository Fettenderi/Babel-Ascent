#[compute]
#version 450

layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;

layout(rgba16f, binding = 0, set = 0) uniform image2D screen_texture;
layout(binding = 0, set = 1) uniform sampler2D depth_texture;

layout(push_constant, std430) uniform Params {
	vec2 screen_size;
	float inv_proj_2w;
	float inv_proj_3w;
} p;

const float pattern2[4] = float[](
	0.0 / 4.0, 2.0 / 4.0,
	3.0 / 4.0, 1.0 / 4.0
);

const float pattern4[16] = float[](
	0.0 / 16.0, 8.0 / 16.0, 2.0 / 16.0, 10.0 / 16.0,
	12.0 / 16.0, 4.0 / 16.0, 14.0 / 16.0, 6.0 / 16.0,
	3.0 / 16.0, 11.0 / 16.0, 1.0 / 16.0, 9.0 / 16.0,
	15.0 / 16.0, 7.0 / 16.0, 13.0 / 16.0, 5.0 / 16.0
);

vec4 effect(vec4 color, ivec2 pixel_position, vec2 uv);

float get_bayer4_value(ivec2 pixel_coord);
float get_bayer2_value(ivec2 pixel_coord);
float get_border(float thickness, vec2 uv);

float sharpened_border(float thickness, vec2 uv);

vec4 image_sharpening(ivec2 position);
float depth_sharpening(vec2 uv);


float btu(int unit);
float get_depth(vec2 uv);

void main() {
	ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
	vec2 size = p.screen_size;
	int down_scaling_factor = 2;

	vec2 uv = pixel * down_scaling_factor / size;

	if (pixel.x >= size.x || pixel.y >= size.y) return;
		
	vec4 color = imageLoad(screen_texture, pixel * down_scaling_factor);
	
	color = effect(color, pixel, uv);
	
	for (int i = 0; i < down_scaling_factor; i++) {
		for (int j = 0; j < down_scaling_factor; j++) {
			imageStore(screen_texture, pixel * down_scaling_factor + ivec2(i, j), color);
		}
	}
}

vec4 effect(vec4 color, ivec2 pixel_position, vec2 uv) {
	float gray = color.r * 0.2125 + color.g * 0.7154 + color.b * 0.0721;
	gray = clamp(get_border(0.002, uv) + gray, 0.0, 1.0);
	
	float dither_value = get_bayer2_value(pixel_position);
	
	if (gray > dither_value + 0.3) {
		color = vec4(vec3(1.0), 1.0);
	} else {
		color = vec4(vec3(0.0), 1.0);
	}
	
	return color;
}


float get_bayer4_value(ivec2 pixel_coord) {
    int index = (pixel_coord.y % 4) * 4 + (pixel_coord.x % 4);
    return pattern4[index];
}

float get_bayer2_value(ivec2 pixel_coord) {
    int index = (pixel_coord.y % 2) * 2 + (pixel_coord.x % 2);
    return pattern2[index];
}

float get_border(float thickness, vec2 uv) {
	return get_depth(uv + vec2(thickness, 0.0)) + get_depth(uv - vec2(thickness, 0.0)) + get_depth(uv + vec2(0.0, thickness)) + get_depth(uv - vec2(0.0, thickness)) - 4.0 * get_depth(uv + vec2(0.0, 0.0));
}

float sharpened_border(float thickness, vec2 uv) {
	return depth_sharpening(uv + vec2(thickness, 0.0)) + depth_sharpening(uv - vec2(thickness, 0.0)) + depth_sharpening(uv + vec2(0.0, thickness)) + depth_sharpening(uv - vec2(0.0, thickness)) - 4.0 * depth_sharpening(uv + vec2(0.0, 0.0));
}

vec4 image_sharpening(ivec2 position) {
	vec4 convo = vec4(0.0);

	convo += imageLoad(screen_texture, position + ivec2(-1, 0)) * -1.0;
	convo += imageLoad(screen_texture, position + ivec2(0, -1)) * -1.0;
	convo += imageLoad(screen_texture, position + ivec2(1, 0)) * -1.0;
	convo += imageLoad(screen_texture, position + ivec2(0, 1)) * -1.0;
	convo += imageLoad(screen_texture, position + ivec2(0, 0)) * 5.0;

	return convo;
}

float depth_sharpening(vec2 uv) {
	float convo = 0.0;

	convo += get_depth(uv + vec2(-1, 0)) * -1.0;
	convo += get_depth(uv + vec2(0, -1)) * -1.0;
	convo += get_depth(uv + vec2(1, 0)) * -1.0;
	convo += get_depth(uv + vec2(0, 1)) * -1.0;
	convo += get_depth(uv + vec2(0, 0)) * 5.0;

	return convo;
}


float btu(int unit) {
	return unit / 255.0;
}

float get_depth(vec2 uv) {
	float depth = texture(depth_texture, uv).r;
	float linear_depth = 1.0 / (depth * p.inv_proj_2w + p.inv_proj_3w);
	return clamp(linear_depth / 100.0, 0.0, 1.0);
}