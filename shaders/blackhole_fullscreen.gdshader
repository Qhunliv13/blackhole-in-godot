shader_type canvas_item;

const float EPSILON = 0.0001;
const float INFINITY = 1000000.0;

uniform float mouse_x : hint_range(0.0, 1.0) = 0.5;
uniform float mouse_y : hint_range(0.0, 1.0) = 0.5;
uniform float time : hint_range(0.0, 100.0) = 0.0;

uniform vec3 camera_position = vec3(0.0, 0.0, 15.0);
uniform vec3 camera_forward = vec3(0.0, 0.0, -1.0);
uniform vec3 camera_up = vec3(0.0, 1.0, 0.0);
uniform vec3 camera_right = vec3(1.0, 0.0, 0.0);
uniform float camera_fov = 75.0;
uniform float use_3d_camera : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D galaxy : hint_default_black;
uniform sampler2D color_map : hint_default_white;
uniform sampler2D background_texture : hint_default_white;

uniform float front_view : hint_range(0.0, 1.0) = 0.0;
uniform float top_view : hint_range(0.0, 1.0) = 0.0;
uniform float camera_roll : hint_range(-180.0, 180.0) = 0.0;

uniform float gravitational_lensing : hint_range(0.0, 1.0) = 1.0;
uniform float gravity_strength : hint_range(0.01, 2.0) = 0.5;
uniform float render_black_hole : hint_range(0.0, 1.0) = 1.0;
uniform float mouse_control : hint_range(0.0, 1.0) = 0.0;
uniform float fov_scale : hint_range(0.1, 3.0) = 1.0;
uniform float auto_fade_lensing : hint_range(0.0, 1.0) = 1.0;

uniform float adisk_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_particle : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_height : hint_range(0.1, 1.0) = 0.5;
uniform float adisk_lit : hint_range(1.0, 100.0, 1.0) = 10.0;
uniform float adisk_density_v : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_density_h : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_noise_scale : hint_range(0.1, 20.0) = 5.0;
uniform float adisk_noise_lod : hint_range(1.0, 16.0) = 12.0;
uniform float adisk_speed : hint_range(0.0, 2.0) = 0.5;
uniform float adisk_multi_noise : hint_range(0.0, 1.0) = 0.0;
uniform float adisk_inner_radius : hint_range(1.0, 5.0) = 1.5;
uniform float adisk_outer_radius : hint_range(5.0, 20.0) = 12.0;

uniform float cube_enabled : hint_range(0.0, 1.0) = 1.0;
uniform vec3 cube_position = vec3(3.0, 0.0, 0.0);
uniform vec3 cube_size = vec3(1.0, 1.0, 1.0);
uniform vec3 cube_color = vec3(0.4, 0.8, 1.0);
uniform float cube_emission_strength : hint_range(0.1, 10.0) = 0.5;

uniform float doppler_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float doppler_strength : hint_range(0.0, 2.0) = 0.8;
uniform float beaming_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float beaming_strength : hint_range(1.0, 5.0) = 2.0;

uniform float jet_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float jet_length : hint_range(5.0, 50.0) = 25.0;
uniform float jet_width : hint_range(0.1, 2.0) = 0.5;
uniform float jet_intensity : hint_range(0.1, 20.0) = 1.0;
uniform float jet_rotation_speed : hint_range(0.0, 5.0) = 2.0;
uniform float jet_burst_frequency : hint_range(0.1, 3.0) = 0.5;
uniform float jet_noise_octaves : hint_range(3.0, 8.0) = 5.0;
uniform vec3 jet_color = vec3(0.3, 0.6, 1.0);

uniform float hawking_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float hawking_intensity : hint_range(0.1, 3.0) = 1.0;
uniform float hawking_frequency : hint_range(0.1, 5.0) = 1.5;

uniform float gravitational_redshift_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float gravitational_redshift_strength : hint_range(0.0, 2.0) = 1.0;

uniform float photon_sphere_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float photon_sphere_intensity : hint_range(0.1, 10.0) = 1.2;
uniform vec3 photon_sphere_color = vec3(1.0, 1.0, 0.95);

uniform float isco_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float isco_intensity : hint_range(0.1, 10.0) = 5.0;
uniform float isco_width : hint_range(0.1, 1.0) = 0.3;
uniform vec3 isco_color = vec3(1.0, 0.9, 0.7);

uniform float corona_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float corona_height : hint_range(1.0, 5.0) = 2.0;
uniform float corona_intensity : hint_range(0.1, 5.0) = 1.5;
uniform vec3 corona_color = vec3(0.9, 0.95, 1.0);

uniform float temperature_gradient_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float disk_temperature_power : hint_range(0.5, 1.0) = 0.75;

uniform float secondary_images_enabled : hint_range(0.0, 1.0) = 0.0;
uniform int max_ray_loops : hint_range(500, 2000) = 500;

uniform float qpo_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float qpo_frequency : hint_range(0.1, 10.0) = 3.0;
uniform float qpo_amplitude : hint_range(0.0, 0.5) = 0.15;

uniform float time_dilation_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float time_dilation_strength : hint_range(0.0, 2.0) = 1.0;

uniform float frame_dragging_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float black_hole_spin : hint_range(0.0, 0.998) = 0.7;
uniform float dragging_strength : hint_range(0.0, 2.0) = 1.0;

uniform float spiral_arms_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float spiral_arms_count : hint_range(1.0, 5.0) = 2.0;
uniform float spiral_tightness : hint_range(0.5, 3.0) = 1.5;
uniform float spiral_strength : hint_range(0.0, 2.0) = 0.8;

uniform float hot_spots_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float hot_spots_count : hint_range(1.0, 8.0) = 3.0;
uniform float hot_spots_intensity : hint_range(0.5, 5.0) = 2.0;
uniform float hot_spots_speed : hint_range(0.0, 3.0) = 1.0;

uniform float lod_level : hint_range(0.0, 5.0) = 0.0;
uniform float distance_to_blackhole = 0.0;

uniform float contrast : hint_range(0.5, 2.0) = 1.2;
uniform float brightness : hint_range(0.5, 1.5) = 1.0;

uniform float hdr_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float hdr_log_compression : hint_range(0.0, 1.0) = 1.0;
uniform float hdr_exposure : hint_range(0.1, 5.0) = 1.0;
uniform float hdr_tonemapping_mode : hint_range(0.0, 2.0) = 1.0;
uniform float hdr_white_point : hint_range(1.0, 10.0) = 4.0;
uniform float clahe_enabled : hint_range(0.0, 1.0) = 0.0;
uniform float clahe_strength : hint_range(0.0, 1.0) = 0.5;

struct Ring {
	vec3 center;
	vec3 normal;
	float inner_radius;
	float outer_radius;
	float rotate_speed;
};

float calculate_isco_radius(float spin) {
	float a = clamp(spin, 0.0, 0.998);
	float a2 = a * a;
	float sqrt_term = pow(1.0 - a2, 1.0/3.0);
	float Z1 = 1.0 + sqrt_term * (pow(1.0 + a, 1.0/3.0) + pow(1.0 - a, 1.0/3.0));
	float Z2 = sqrt(3.0 * a2 + Z1 * Z1);
	float r_isco_M = 3.0 + Z2 - sqrt((3.0 - Z1) * (3.0 + Z1 + 2.0 * Z2));
	return r_isco_M * 0.5;
}

float calculate_photon_sphere_radius(float spin) {
	float a = clamp(spin, 0.0, 0.998);
	float cos_arg = clamp(-a, -1.0, 1.0);
	float r_ph = 2.0 * (1.0 + cos((2.0/3.0) * acos(cos_arg)));
	return r_ph * 0.5;
}

float calculate_orbital_frequency(float r, float spin) {
	float a = clamp(spin, 0.0, 0.998);
	float M = 1.0;
	float base_omega = sqrt(M / (r * r * r));
	float frame_drag_factor = 1.0 + a * sqrt(M) / pow(r, 1.5);
	return base_omega * frame_drag_factor;
}

float calculate_epicyclic_frequency(float r, float spin) {
	float omega = calculate_orbital_frequency(r, spin);
	float dln_omega2_dr = -3.0 / r;
	float kappa_factor = sqrt(max(0.0, 1.0 + r * dln_omega2_dr));
	return omega * kappa_factor;
}

float calculate_combined_redshift(vec3 pos, vec3 velocity, vec3 to_camera) {
	float r = length(pos);
	float schwarzschild_radius = 1.0;
	if (r <= schwarzschild_radius) return 1000.0;
	
	float grav_term = sqrt(1.0 - schwarzschild_radius / r);
	
	if (length(velocity) > 0.001) {
		float beta = min(length(velocity), 0.99);
		vec3 vel_dir = normalize(velocity);
		float cos_angle = dot(vel_dir, to_camera);
		float doppler_term = max(0.01, 1.0 - beta * cos_angle);
		return grav_term / doppler_term;
	}
	
	return 1.0 / grav_term;
}

vec4 permute(vec4 x) { 
	return mod(((x * 34.0) + 1.0) * x, 289.0); 
}

vec4 taylorInvSqrt(vec4 r) { 
	return 1.79284291400159 - 0.85373472095314 * r; 
}

float simplex_noise_3d(vec3 v) {
	const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
	const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

	vec3 i = floor(v + dot(v, C.yyy));
	vec3 x0 = v - i + dot(i, C.xxx);

	vec3 g = step(x0.yzx, x0.xyz);
	vec3 l = 1.0 - g;
	vec3 i1 = min(g.xyz, l.zxy);
	vec3 i2 = max(g.xyz, l.zxy);

	vec3 x1 = x0 - i1 + 1.0 * C.xxx;
	vec3 x2 = x0 - i2 + 2.0 * C.xxx;
	vec3 x3 = x0 - 1. + 3.0 * C.xxx;

	i = mod(i, 289.0);
	vec4 p = permute(permute(permute(i.z + vec4(0.0, i1.z, i2.z, 1.0)) + i.y +
	                         vec4(0.0, i1.y, i2.y, 1.0)) +
	                 i.x + vec4(0.0, i1.x, i2.x, 1.0));

	float n_ = 1.0 / 7.0;
	vec3 ns = n_ * D.wyz - D.xzx;

	vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

	vec4 x_ = floor(j * ns.z);
	vec4 y_ = floor(j - 7.0 * x_);

	vec4 x = x_ * ns.x + ns.yyyy;
	vec4 y = y_ * ns.x + ns.yyyy;
	vec4 h = 1.0 - abs(x) - abs(y);

	vec4 b0 = vec4(x.xy, y.xy);
	vec4 b1 = vec4(x.zw, y.zw);

	vec4 s0 = floor(b0) * 2.0 + 1.0;
	vec4 s1 = floor(b1) * 2.0 + 1.0;
	vec4 sh = -step(h, vec4(0.0));

	vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
	vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

	vec3 p0 = vec3(a0.xy, h.x);
	vec3 p1 = vec3(a0.zw, h.y);
	vec3 p2 = vec3(a1.xy, h.z);
	vec3 p3 = vec3(a1.zw, h.w);

	vec4 norm = taylorInvSqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
	p0 *= norm.x;
	p1 *= norm.y;
	p2 *= norm.z;
	p3 *= norm.w;

	vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
	m = m * m;
	return 42.0 * dot(m * m, vec4(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
}

vec3 hash_3d(vec3 p) {
	p = vec3(dot(p, vec3(127.1, 311.7, 74.7)),
	         dot(p, vec3(269.5, 183.3, 246.1)),
	         dot(p, vec3(113.5, 271.9, 124.6)));
	return fract(sin(p) * 43758.5453123);
}

vec2 voronoi_noise(vec3 x) {
	vec3 p = floor(x);
	vec3 f = fract(x);
	
	float min_dist = 8.0;
	vec3 min_point = vec3(0.0);
	
	for(int k = -1; k <= 1; k++) {
		for(int j = -1; j <= 1; j++) {
			for(int i = -1; i <= 1; i++) {
				vec3 b = vec3(float(i), float(j), float(k));
				vec3 r = b + hash_3d(p + b) - f;
				float d = dot(r, r);
				
				if(d < min_dist) {
					min_dist = d;
					min_point = r;
				}
			}
		}
	}
	
	return vec2(sqrt(min_dist), 1.0);
}

float turbulence_noise(vec3 p, int octaves) {
	float sum = 0.0;
	float freq = 1.0;
	float amp = 1.0;
	
	for(int i = 0; i < octaves; i++) {
		sum += abs(simplex_noise_3d(p * freq)) * amp;
		freq *= 2.0;
		amp *= 0.5;
	}
	
	return sum;
}

float ridge_noise(vec3 p, int octaves) {
	float sum = 0.0;
	float freq = 1.0;
	float amp = 1.0;
	
	for(int i = 0; i < octaves; i++) {
		float n = abs(simplex_noise_3d(p * freq));
		n = 1.0 - n;
		n = n * n;
		sum += n * amp;
		freq *= 2.0;
		amp *= 0.5;
	}
	
	return sum;
}

float domain_warped_noise(vec3 p, float warp_strength) {
	vec3 q = vec3(
		simplex_noise_3d(p + vec3(0.0, 0.0, 0.0)),
		simplex_noise_3d(p + vec3(5.2, 1.3, 2.8)),
		simplex_noise_3d(p + vec3(1.7, 9.2, 4.1))
	);
	
	vec3 r = vec3(
		simplex_noise_3d(p + warp_strength * q + vec3(1.7, 9.2, 4.1)),
		simplex_noise_3d(p + warp_strength * q + vec3(8.3, 2.8, 5.6)),
		simplex_noise_3d(p + warp_strength * q + vec3(3.4, 7.1, 9.3))
	);
	
	return simplex_noise_3d(p + warp_strength * r);
}

float fractal_brownian_motion(vec3 p, int octaves, float lacunarity, float gain) {
	float sum = 0.0;
	float amp = 1.0;
	float freq = 1.0;
	float total_amp = 0.0;
	
	for(int i = 0; i < octaves; i++) {
		sum += simplex_noise_3d(p * freq) * amp;
		total_amp += amp;
		freq *= lacunarity;
		amp *= gain;
	}
	
	return sum / total_amp;
}

vec3 aces_tonemap(vec3 color) {
	float a = 2.51;
	float b = 0.03;
	float c = 2.43;
	float d = 0.59;
	float e = 0.14;
	return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0, 1.0);
}

vec3 reinhard_tonemap(vec3 color, float white_point) {
	float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
	float mapped_lum = (luminance * (1.0 + luminance / (white_point * white_point))) / (1.0 + luminance);
	return color * (mapped_lum / max(luminance, 0.0001));
}

vec3 log_compression(vec3 color, float strength) {
	vec3 compressed = log(vec3(1.0) + color) / log(vec3(2.0));
	return mix(color, compressed, strength);
}

vec3 adaptive_contrast(vec3 color, float strength) {
	float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
	float contrast_boost = 1.0 + strength * (1.0 - lum) * lum * 4.0;
	vec3 boosted = (color - lum) * contrast_boost + lum;
	
	return clamp(boosted, 0.0, 1.0);
}

vec3 apply_hdr_pipeline(vec3 color) {
	if (hdr_enabled < 0.5) {
		return color;
	}
	
	vec3 exposed = color * hdr_exposure;
	
	if (hdr_log_compression > 0.01) {
		exposed = log_compression(exposed, hdr_log_compression);
	}
	
	vec3 tone_mapped;
	if (hdr_tonemapping_mode < 0.5) {
		tone_mapped = clamp(exposed, 0.0, 1.0);
	} else if (hdr_tonemapping_mode < 1.5) {
		tone_mapped = aces_tonemap(exposed);
	} else {
		tone_mapped = reinhard_tonemap(exposed, hdr_white_point);
	}
	
	if (clahe_enabled > 0.5) {
		tone_mapped = adaptive_contrast(tone_mapped, clahe_strength);
	}
	
	return tone_mapped;
}

vec3 inverse_hdr_pipeline(vec3 color) {
	if (hdr_enabled < 0.5) {
		return color;
	}
	
	vec3 result = color;
	
	if (clahe_enabled > 0.5) {
		float lum = dot(result, vec3(0.2126, 0.7152, 0.0722));
		float contrast_reduce = 1.0 / (1.0 + clahe_strength * (1.0 - lum) * lum * 4.0);
		result = (result - lum) * contrast_reduce + lum;
		result = clamp(result, 0.0, 1.0);
	}
	
	if (hdr_tonemapping_mode < 0.5) {
	} else if (hdr_tonemapping_mode < 1.5) {
		result = result / (vec3(1.02) - result * 0.98);
		result = clamp(result, 0.0, 10.0);
	} else {
		float lum = dot(result, vec3(0.2126, 0.7152, 0.0722));
		float white_sq = hdr_white_point * hdr_white_point;
		float inv_lum = (lum * white_sq) / (white_sq - lum);
		result = result * (inv_lum / max(lum, 0.0001));
		result = clamp(result, 0.0, 10.0);
	}
	
	if (hdr_log_compression > 0.01) {
		vec3 uncompressed = (exp(result * log(2.0)) - vec3(1.0));
		result = mix(result, uncompressed, hdr_log_compression);
		result = clamp(result, 0.0, 10.0);
	}
	
	result = result / hdr_exposure;
	
	return result;
}

float ring_distance(vec3 ray_origin, vec3 ray_dir, Ring ring) {
	float denominator = dot(ray_dir, ring.normal);
	float constant = -dot(ring.center, ring.normal);
	if (abs(denominator) < EPSILON) {
		return -1.0;
	} else {
		float t = -(dot(ray_origin, ring.normal) + constant) / denominator;
		if (t < 0.0) {
			return -1.0;
		}

		vec3 intersection = ray_origin + t * ray_dir;
		float d = length(intersection - ring.center);
		if (d >= ring.inner_radius && d <= ring.outer_radius) {
			return t;
		}
		return -1.0;
	}
}

vec3 calculate_gravitational_acceleration(float h2, vec3 pos) {
	float r2 = dot(pos, pos);
	float r5 = pow(r2, 2.5);
	vec3 acc = -1.5 * h2 * pos / r5 * gravity_strength;
	return acc;
}

vec4 quaternion_from_axis_angle(vec3 axis, float angle) {
	vec4 qr;
	float half_angle = (angle * 0.5) * PI / 180.0;
	qr.x = axis.x * sin(half_angle);
	qr.y = axis.y * sin(half_angle);
	qr.z = axis.z * sin(half_angle);
	qr.w = cos(half_angle);
	return qr;
}

vec4 quaternion_conjugate(vec4 q) { 
	return vec4(-q.x, -q.y, -q.z, q.w); 
}

vec4 quaternion_multiply(vec4 q1, vec4 q2) {
	vec4 qr;
	qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
	qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
	qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
	qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
	return qr;
}

vec3 rotate_vector_by_quaternion(vec3 position, vec3 axis, float angle) {
	vec4 qr = quaternion_from_axis_angle(axis, angle);
	vec4 qr_conj = quaternion_conjugate(qr);
	vec4 q_pos = vec4(position.x, position.y, position.z, 0);

	vec4 q_tmp = quaternion_multiply(qr, q_pos);
	qr = quaternion_multiply(q_tmp, qr_conj);

	return vec3(qr.x, qr.y, qr.z);
}

vec3 cartesian_to_spherical(vec3 p) {
	float rho = sqrt((p.x * p.x) + (p.y * p.y) + (p.z * p.z));
	float theta = atan(p.z, p.x);
	float phi = asin(p.y / rho);
	return vec3(rho, theta, phi);
}

mat3 calculate_look_at_matrix(vec3 origin, vec3 target, float roll) {
	vec3 world_up = vec3(0.0, 1.0, 0.0);
	vec3 forward = normalize(target - origin);
	
	vec3 temp_up = world_up;
	if (abs(dot(forward, world_up)) > 0.999) {
		temp_up = vec3(0.0, 0.0, 1.0);
	}
	
	vec3 right = normalize(cross(forward, temp_up));
	vec3 up = normalize(cross(right, forward));
	
	if (abs(roll) > 0.001) {
		float c = cos(roll);
		float s = sin(roll);
		vec3 new_right = right * c + up * s;
		vec3 new_up = -right * s + up * c;
		right = new_right;
		up = new_up;
	}

	return mat3(right, up, forward);
}

void calculate_accretion_disk_contribution(vec3 pos, vec3 cam_pos, inout vec3 color, inout float alpha, float physics_decay) {
	if (adisk_lit < 0.1) {
		return;
	}
	
	float inner_radius = adisk_inner_radius;
	float outer_radius = adisk_outer_radius;

	float density = max(0.0, 1.0 - length(pos.xyz / vec3(outer_radius, adisk_height, outer_radius)));
	if (density < 0.001) {
		return;
	}

	density *= pow(1.0 - abs(pos.y) / adisk_height, adisk_density_v);
	density *= smoothstep(inner_radius, inner_radius * 1.1, length(pos));

	if (density < 0.001) {
		return;
	}

	vec3 disk_pos = pos;
	float radial_dist = length(disk_pos.xz);

	density *= 1.0 / pow(radial_dist, adisk_density_h);
	density *= 16000.0;
	if (adisk_particle < 0.5) {
		color += vec3(0.0, 1.0, 0.0) * density * 0.02;
		return;
	}

	float normalized_radius = radial_dist / inner_radius;
	float angular_velocity = 1.0 / pow(max(normalized_radius, 0.2), 0.75);
	
	float local_time = time;
	if (time_dilation_enabled > 0.5) {
		float r = length(pos);
		float schwarzschild_radius = 1.0;
		if (r > schwarzschild_radius) {
			float time_factor = sqrt(1.0 - schwarzschild_radius / r);
			local_time = time * time_factor * (1.0 - time_dilation_strength * (1.0 - time_factor));
		}
	}
	
	float rotation_angle = local_time * adisk_speed * angular_velocity;
	
	if (frame_dragging_enabled > 0.5) {
		float r = length(pos);
		float schwarzschild_radius = 1.0;
		
		if (r > schwarzschild_radius && r < outer_radius * 1.5) {
			float a = black_hole_spin;
			float r_sqr = r * r;
			float drag_omega = (2.0 * a * schwarzschild_radius) / (r_sqr * r + a * a * r + 2.0 * a * a * schwarzschild_radius);
			float drag_angle = drag_omega * local_time * dragging_strength;
			rotation_angle += drag_angle;
		}
	}
	
	float c_main = cos(rotation_angle);
	float s_main = sin(rotation_angle);
	
	vec3 rotated_pos = vec3(
		disk_pos.x * c_main - disk_pos.z * s_main,
		disk_pos.y,
		disk_pos.x * s_main + disk_pos.z * c_main
	);

	float noise = 0.0;
	float amplitude = 1.0;
	float total_amplitude = 0.0;
	
	int lod_count = max(int(adisk_noise_lod), 6);
	
	for (int i = 0; i < lod_count; i++) {
		float frequency = pow(2.0, float(i)) * adisk_noise_scale;
		
		float layer_speed_factor = 1.0 + float(i) * 0.1;
		float layer_angle = rotation_angle * layer_speed_factor;
		float c_layer = cos(layer_angle);
		float s_layer = sin(layer_angle);
		
		vec3 layer_rotated = vec3(
			rotated_pos.x * c_layer - rotated_pos.z * s_layer,
			rotated_pos.y,
			rotated_pos.x * s_layer + rotated_pos.z * c_layer
		);
		
		float n = simplex_noise_3d(layer_rotated * frequency) * 0.5 + 0.5;
		noise += n * amplitude;
		total_amplitude += amplitude;
		amplitude *= 0.5;
	}
	
	noise /= total_amplitude;

	vec3 detail_pos = vec3(
		rotated_pos.x * c_main - rotated_pos.z * s_main,
		rotated_pos.y,
		rotated_pos.x * s_main + rotated_pos.z * c_main
	);
	
	float fine_detail;
	
	if (adisk_multi_noise >= 0.5) {
		float detail1 = simplex_noise_3d(detail_pos * adisk_noise_scale * 32.0) * 0.5 + 0.5;
		float detail2 = simplex_noise_3d(detail_pos * adisk_noise_scale * 64.0) * 0.5 + 0.5;
		float detail3 = simplex_noise_3d(detail_pos * adisk_noise_scale * 128.0) * 0.5 + 0.5;
		
		vec2 voronoi_result = voronoi_noise(detail_pos * adisk_noise_scale * 6.0);
		float voronoi_val = 1.0 - voronoi_result.x;
		voronoi_val = pow(voronoi_val, 1.5);
		
		float turb = turbulence_noise(detail_pos * adisk_noise_scale * 4.0, 4) * 0.5;
		float ridge = ridge_noise(detail_pos * adisk_noise_scale * 6.0, 4);
		float warped = domain_warped_noise(detail_pos * adisk_noise_scale * 3.0, 1.0) * 0.5 + 0.5;
		float fractal = fractal_brownian_motion(detail_pos * adisk_noise_scale * 5.0, 5, 2.2, 0.6) * 0.5 + 0.5;
		
		fine_detail = detail1 * 0.20 +
		              detail2 * 0.12 +
		              detail3 * 0.08 +
		              voronoi_val * 0.30 +
		              turb * 0.12 +
		              ridge * 0.08 +
		              warped * 0.06 +
		              fractal * 0.04;
		
		noise = mix(noise, fine_detail, 0.7);
	} else {
		float detail1 = simplex_noise_3d(detail_pos * adisk_noise_scale * 32.0) * 0.5 + 0.5;
		float detail2 = simplex_noise_3d(detail_pos * adisk_noise_scale * 64.0) * 0.5 + 0.5;
		float detail3 = simplex_noise_3d(detail_pos * adisk_noise_scale * 128.0) * 0.5 + 0.5;
		
		fine_detail = detail1 * 0.5 + detail2 * 0.3 + detail3 * 0.2;
		noise = mix(noise, fine_detail, 0.4);
	}

	vec3 intrinsic_color;
	
	if (temperature_gradient_enabled > 0.5) {
		float temp_ratio = pow(inner_radius / max(radial_dist, inner_radius), disk_temperature_power);
		
		vec3 uv_white = vec3(0.95, 0.97, 1.0);
		vec3 blue_white = vec3(0.8, 0.9, 1.0);
		vec3 yellow = vec3(1.0, 0.9, 0.6);
		vec3 orange_red = vec3(1.0, 0.4, 0.1);
		
		if (temp_ratio > 0.7) {
			intrinsic_color = mix(blue_white, uv_white, (temp_ratio - 0.7) / 0.3);
		} else if (temp_ratio > 0.4) {
			intrinsic_color = mix(yellow, blue_white, (temp_ratio - 0.4) / 0.3);
		} else {
			intrinsic_color = mix(orange_red, yellow, temp_ratio / 0.4);
		}
	} else {
		intrinsic_color = texture(color_map, vec2(radial_dist / outer_radius, 0.5)).rgb;
	}
	
	vec3 dust_color = intrinsic_color;
	float total_energy_factor = 1.0;
	
	if (doppler_enabled > 0.5 && physics_decay > 0.01) {
		vec3 radial_dir = normalize(vec3(disk_pos.x, 0.0, disk_pos.z));
		vec3 tangent_dir = vec3(-radial_dir.z, 0.0, radial_dir.x);
		if (adisk_speed < 0.0) {
			tangent_dir = -tangent_dir;
		}
		
		float orbital_speed = angular_velocity * radial_dist;
		float beta = orbital_speed * abs(adisk_speed) * 0.2;
		beta = clamp(beta, 0.0, 0.6);
		
		vec3 velocity = tangent_dir * beta;
		vec3 view_dir = normalize(cam_pos - pos);
		float cos_theta = dot(normalize(velocity), view_dir);
		
		if (beaming_enabled > 0.5) {
			float beta_sq = beta * beta;
			float gamma = 1.0 / sqrt(max(1.0 - beta_sq, 0.01));
			float doppler_factor = 1.0 / (gamma * (1.0 - beta * cos_theta));
			
			total_energy_factor *= doppler_factor;
			
			float beaming_boost = pow(clamp(doppler_factor, 0.1, 10.0), beaming_strength * physics_decay);
			beaming_boost = clamp(beaming_boost, 0.1, 10.0);
			total_energy_factor = beaming_boost;
		} else {
			float doppler_boost = 1.0 / (1.0 - beta * cos_theta);
			total_energy_factor *= doppler_boost;
		}
		
		float effective_temp_shift = pow(total_energy_factor, 0.25);
		
		if (effective_temp_shift > 1.0) {
			dust_color = mix(dust_color, vec3(0.7, 0.85, 1.0), (effective_temp_shift - 1.0) * doppler_strength * physics_decay * 0.5);
		} else {
			dust_color = mix(dust_color, vec3(1.0, 0.5, 0.2), (1.0 - effective_temp_shift) * doppler_strength * physics_decay * 0.5);
		}
	}
	
	if (gravitational_redshift_enabled > 0.5 && doppler_enabled > 0.5 && physics_decay > 0.01) {
		vec3 radial_dir = normalize(vec3(disk_pos.x, 0.0, disk_pos.z));
		vec3 tangent_dir = vec3(-radial_dir.z, 0.0, radial_dir.x);
		if (adisk_speed < 0.0) tangent_dir = -tangent_dir;
		
		float orbital_speed = angular_velocity * radial_dist;
		float beta = orbital_speed * abs(adisk_speed) * 0.2;
		beta = clamp(beta, 0.0, 0.6);
		vec3 velocity = tangent_dir * beta;
		vec3 to_camera = normalize(cam_pos - pos);
		
		float combined_z_plus_one = calculate_combined_redshift(pos, velocity, to_camera);
		
		if (combined_z_plus_one < 100.0) {
			float grav_shift = (combined_z_plus_one - 1.0) * gravitational_redshift_strength * physics_decay;
			dust_color = mix(dust_color, vec3(1.0, 0.4, 0.1), grav_shift * 0.3);
			
			float energy_loss = 1.0 / (combined_z_plus_one * combined_z_plus_one);
			total_energy_factor *= energy_loss;
		}
	} else if (gravitational_redshift_enabled > 0.5 && physics_decay > 0.01) {
		float r = length(pos);
		float schwarzschild_radius = 1.0;
		
		if (r > schwarzschild_radius) {
			float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
			float redshift_factor = 1.0 / z_plus_one;
			
			float grav_shift = z_plus_one - 1.0;
			float color_shift = grav_shift * gravitational_redshift_strength;
			
			dust_color = mix(dust_color, vec3(1.0, 0.4, 0.1), color_shift * 0.3);
			
			float energy_loss = pow(redshift_factor, 2.0);
			total_energy_factor *= energy_loss;
		}
	}
	
	float density_modulation = 1.0;
	
	if (spiral_arms_enabled > 0.5) {
		float angle = atan(disk_pos.z, disk_pos.x);
		
		float pattern_speed = angular_velocity * 0.7;
		float spiral_phase = angle * spiral_arms_count - log(radial_dist / inner_radius) * spiral_tightness;
		spiral_phase += local_time * adisk_speed * pattern_speed;
		
		float spiral_wave = sin(spiral_phase) * 0.5 + 0.5;
		spiral_wave = pow(spiral_wave, 1.5);
		
		float toomre_factor = smoothstep(outer_radius * 0.8, inner_radius * 1.2, radial_dist);
		float arm_contrast = 1.5 + spiral_wave * spiral_strength * 2.5;
		arm_contrast = mix(1.0, arm_contrast, toomre_factor);
		
		density_modulation *= arm_contrast;
	}
	
	if (hot_spots_enabled > 0.5) {
		float angle = atan(disk_pos.z, disk_pos.x);
		
		float isco_outer = 4.0;
		float isco_radius_calc = calculate_isco_radius(black_hole_spin);
		float spot_orbit_radius = mix(isco_radius_calc, isco_outer, 0.5);
		float spot_angular_vel = calculate_orbital_frequency(spot_orbit_radius, black_hole_spin);
		float spot_rotation = angle + local_time * spot_angular_vel * hot_spots_speed;
		
		float spots = 0.0;
		float max_spot = 0.0;
		for (int i = 0; i < int(hot_spots_count); i++) {
			float spot_angle = spot_rotation - float(i) * TAU / hot_spots_count;
			float spot_peak = sin(spot_angle) * 0.5 + 0.5;
			spot_peak = pow(spot_peak, 12.0);
			
			float lifetime_phase = fract(local_time * 0.05 + float(i) * 0.3);
			float lifetime = smoothstep(0.0, 0.1, lifetime_phase) * smoothstep(1.0, 0.8, lifetime_phase);
			
			spots += spot_peak * lifetime;
			max_spot = max(max_spot, spot_peak * lifetime);
		}
		
		float radial_profile = exp(-pow((radial_dist - spot_orbit_radius) / 1.0, 2.0) * 2.0);
		float vertical_profile = exp(-pow(pos.y / (adisk_height * 0.5), 2.0));
		
		float spot_strength = max_spot * radial_profile * vertical_profile;
		float hot_spot_boost = 1.0 + spot_strength * hot_spots_intensity * 20.0;
		
		density_modulation *= hot_spot_boost;
	}
	
	float qpo_modulation = 1.0;
	if (qpo_enabled > 0.5) {
		float qpo_phase = local_time * qpo_frequency * TAU;
		float qpo_wave = sin(qpo_phase) * 0.5 + 0.5;
		qpo_modulation = 1.0 - qpo_amplitude + qpo_amplitude * qpo_wave;
	}
	
	float final_contribution = density * (adisk_lit / 100000.0) * noise * density_modulation * qpo_modulation * total_energy_factor;
	if (final_contribution > 0.00001) {
		color += dust_color * alpha * final_contribution;
	}
}

void calculate_corona_contribution(vec3 pos, inout vec3 color, inout float alpha) {
	if (corona_enabled < 0.5 || corona_intensity < 0.01) {
		return;
	}
	
	float radial_dist = length(vec2(pos.x, pos.z));
	float y_dist = abs(pos.y);
	
	if (radial_dist < adisk_outer_radius && y_dist > adisk_height && y_dist < corona_height) {
		float radial_factor = smoothstep(adisk_outer_radius, adisk_inner_radius, radial_dist);
		float height_factor = exp(-pow((y_dist - adisk_height) / (corona_height - adisk_height), 2.0));
		
		float corona_density = radial_factor * height_factor;
		
		if (corona_density > 0.01) {
			float flicker = simplex_noise_3d(pos * 5.0 + vec3(time * 1.5)) * 0.5 + 0.5;
			float detail = simplex_noise_3d(pos * 15.0 + vec3(time * 3.0)) * 0.5 + 0.5;
			float combined = mix(flicker, detail, 0.4);
			
			float intensity = corona_density * combined * corona_intensity;
			vec3 corona_emission = corona_color * intensity;
			
			if (gravitational_redshift_enabled > 0.5) {
				float r = length(pos);
				float schwarzschild_radius = 1.0;
				if (r > schwarzschild_radius) {
					float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
					float redshift_factor = 1.0 / z_plus_one;
					float wavelength_shift = (z_plus_one - 1.0) * gravitational_redshift_strength;
					
					corona_emission.r *= (1.0 + wavelength_shift * 0.8);
					corona_emission.g *= (1.0 - wavelength_shift * 0.1);
					corona_emission.b *= (1.0 - wavelength_shift * 1.2);
					
					float energy_loss = pow(redshift_factor, 2.0);
					corona_emission *= energy_loss;
				}
			}
			
			if (intensity > 0.001) {
				color += corona_emission * alpha * 0.02;
				alpha *= 0.98;
			}
		}
	}
}

void calculate_jet_contribution(vec3 pos, inout vec3 color, inout float alpha) {
	if (jet_enabled < 0.5 || jet_intensity < 0.01) {
		return;
	}
	
	vec3 jet_axis = vec3(0.0, 1.0, 0.0);
	float y_pos = abs(pos.y);
	
	float jet_start = 1.0;
	
	if (y_pos > jet_start && y_pos < jet_length) {
		float distance_from_start = y_pos - jet_start;
		float normalized_distance = distance_from_start / (jet_length - jet_start);
		
		float dist_to_axis = length(vec2(pos.x, pos.z));
		
		float tip_smoothness = smoothstep(0.0, 0.5, distance_from_start);
		float base_expansion = pow(normalized_distance, 0.7);
		float expansion_factor = tip_smoothness * (0.02 + base_expansion * 4.0);
		float dynamic_width = jet_width * expansion_factor;
		
		if (dist_to_axis < dynamic_width) {
			float length_factor = smoothstep(jet_length, jet_length * 0.5, y_pos);
			float width_factor = 1.0 - smoothstep(dynamic_width * 0.3, dynamic_width, dist_to_axis);
			
			float formation_boost = smoothstep(0.0, 1.0, distance_from_start);
			
			float core_radius = dynamic_width * 0.15;
			float core_factor = smoothstep(core_radius * 2.0, core_radius, dist_to_axis);
			float edge_factor = (1.0 - core_factor) * width_factor;
			float combined_profile = core_factor * 1.0 + edge_factor * 0.4;
			
			float base_intensity = length_factor * combined_profile * formation_boost;
			
			vec3 moving_pos = pos - vec3(0.0, sign(pos.y) * time * 3.0, 0.0);
			
			float burst_cycle = time * jet_burst_frequency;
			float burst_phase = fract(burst_cycle);
			float burst_strength = smoothstep(0.0, 0.2, burst_phase) * smoothstep(1.0, 0.6, burst_phase);
			float propagation_delay = normalized_distance * 0.5;
			float delayed_burst = smoothstep(0.0, 0.3, burst_phase - propagation_delay) * 
			                      smoothstep(1.2, 0.7, burst_phase - propagation_delay);
			burst_strength = max(burst_strength, delayed_burst * 0.7);
			float activity_level = 0.3 + burst_strength * 0.7;
			
			float multi_octave_noise = 0.0;
			float amplitude = 1.0;
			float total_amplitude = 0.0;
			int octaves = int(jet_noise_octaves);
			
			for (int i = 0; i < octaves; i++) {
				float frequency = pow(2.0, float(i));
				
				float rotation_freq = time * jet_rotation_speed * (1.0 + float(i) * 0.1);
				float c = cos(rotation_freq);
				float s = sin(rotation_freq);
				vec3 rotated_sample = vec3(
					moving_pos.x * c - moving_pos.z * s,
					moving_pos.y,
					moving_pos.x * s + moving_pos.z * c
				);
				
				vec3 sample_pos = rotated_sample * frequency;
				float layer_noise = simplex_noise_3d(sample_pos) * 0.5 + 0.5;
				multi_octave_noise += layer_noise * amplitude;
				total_amplitude += amplitude;
				amplitude *= 0.5;
			}
			multi_octave_noise /= total_amplitude;
			
			float combined_noise = multi_octave_noise * activity_level;
			
			float velocity_boost = 1.0 + normalized_distance * 0.5;
			float density_falloff = 1.0 / (1.0 + normalized_distance * 1.5);
			
			float near_base_boost = 1.0 + smoothstep(1.0, 0.0, distance_from_start) * 2.0;
			
			float brightness_pulse = 1.0 + sin(time * 3.0 + normalized_distance * 10.0) * 0.3;
			float burst_intensity_boost = 1.0 + burst_strength * 2.0;
			
			float intensity = base_intensity * combined_noise * jet_intensity * density_falloff * velocity_boost * brightness_pulse * near_base_boost * burst_intensity_boost;
			
			vec3 enhanced_color = jet_color;
			if (core_factor > 0.5) {
				enhanced_color = mix(jet_color, vec3(1.0, 1.0, 1.0), core_factor * 0.5);
			}
			
			float tip_intensity = smoothstep(0.0, 0.3, distance_from_start);
			enhanced_color = mix(vec3(1.0, 1.0, 1.0), enhanced_color, tip_intensity);
			
			vec3 jet_emission = enhanced_color * intensity;
			
			if (gravitational_redshift_enabled > 0.5) {
				float r = length(pos);
				float schwarzschild_radius = 1.0;
				if (r > schwarzschild_radius) {
					float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
					float redshift_factor = 1.0 / z_plus_one;
					float wavelength_shift = (z_plus_one - 1.0) * gravitational_redshift_strength;
					
					jet_emission.r *= (1.0 + wavelength_shift * 0.8);
					jet_emission.g *= (1.0 - wavelength_shift * 0.1);
					jet_emission.b *= (1.0 - wavelength_shift * 1.2);
					
					float energy_loss = pow(redshift_factor, 2.0);
					jet_emission *= energy_loss;
				}
			}
			
			if (intensity > 0.01) {
				color += jet_emission * alpha * 0.1;
				alpha *= 0.9;
			}
		}
	}
}

void calculate_photon_sphere_contribution(vec3 pos, inout vec3 color, inout float alpha) {
	if (photon_sphere_enabled < 0.5 || photon_sphere_intensity < 0.01) {
		return;
	}
	
	float photon_sphere_radius = calculate_photon_sphere_radius(black_hole_spin);
	float r = length(pos);
	float shell_thickness = 0.15;
	
	float dist_to_shell = abs(r - photon_sphere_radius);
	
	if (dist_to_shell < shell_thickness) {
		float shell_factor = 1.0 - smoothstep(0.0, shell_thickness, dist_to_shell);
		
		float radial_falloff = smoothstep(photon_sphere_radius * 1.3, photon_sphere_radius * 0.9, r);
		shell_factor *= radial_falloff;
		
		float shimmer = simplex_noise_3d(pos * 30.0 + vec3(time * 3.0)) * 0.5 + 0.5;
		shimmer = pow(shimmer, 2.0);
		shell_factor *= (0.7 + shimmer * 0.3);
		
		float wave = sin(atan(pos.z, pos.x) * 8.0 + time * 4.0) * 0.5 + 0.5;
		float pattern = mix(shimmer, wave, 0.5);
		
		float intensity = shell_factor * pattern * photon_sphere_intensity;
		vec3 photon_glow = photon_sphere_color * intensity;
		
		if (gravitational_redshift_enabled > 0.5) {
			float schwarzschild_radius = 1.0;
			if (r > schwarzschild_radius) {
				float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
				float redshift_factor = 1.0 / z_plus_one;
				float wavelength_shift = (z_plus_one - 1.0) * gravitational_redshift_strength;
				
				photon_glow.r *= (1.0 + wavelength_shift * 0.4);
				photon_glow.g *= (1.0 + wavelength_shift * 0.1);
				photon_glow.b *= (1.0 - wavelength_shift * 0.6);
				
				float energy_loss = pow(redshift_factor, 2.0);
				photon_glow *= energy_loss;
			}
		}
		
		if (intensity > 0.01) {
			color += photon_glow * alpha * 0.05;
			alpha *= 0.95;
		}
	}
	
	float halo_radius = photon_sphere_radius * 1.5;
	float halo_dist = abs(r - halo_radius);
	float halo_strength = exp(-halo_dist * 5.0) * 0.3;
	vec3 halo_color = vec3(1.0, 0.9, 0.7) * halo_strength;
	color += halo_color * alpha * 0.1;
}

void calculate_isco_ring_contribution(vec3 pos, inout vec3 color, inout float alpha) {
	if (isco_enabled < 0.5 || isco_intensity < 0.01) {
		return;
	}
	
	float isco_radius = calculate_isco_radius(black_hole_spin);
	float radial_dist = length(vec2(pos.x, pos.z));
	float vertical_dist = abs(pos.y);
	
	if (vertical_dist < adisk_height * 1.2) {
		float ring_dist = abs(radial_dist - isco_radius);
		float inner_blend = isco_width * 0.5;
		float outer_blend = isco_width * 2.0;
		
		if (ring_dist < outer_blend) {
			float core_profile = exp(-pow(ring_dist / inner_blend, 2.0) * 2.0);
			float extended_profile = exp(-pow(ring_dist / outer_blend, 2.0) * 0.5);
			float ring_factor = max(core_profile, extended_profile * 0.2);
			
			float vertical_factor = exp(-pow(vertical_dist / (adisk_height * 0.8), 2.0));
			vertical_factor = pow(vertical_factor, 0.3);
			
			float angle = atan(pos.z, pos.x);
			float rotation = angle + time * 1.5;
			float hotspots = sin(rotation * 5.0) * 0.5 + 0.5;
			hotspots = pow(hotspots, 2.0);
			
			float flicker = simplex_noise_3d(vec3(angle * 3.0, time * 2.0, 0.0)) * 0.5 + 0.5;
			float turbulence = simplex_noise_3d(pos * 8.0 + vec3(0.0, time * 3.0, 0.0)) * 0.5 + 0.5;
			
			float combined_activity = mix(hotspots, mix(flicker, turbulence, 0.5), 0.4);
			combined_activity = 0.5 + combined_activity * 0.5;
			
			float intensity = ring_factor * vertical_factor * combined_activity * isco_intensity;
			vec3 isco_glow = isco_color * intensity;
			
			if (gravitational_redshift_enabled > 0.5) {
				float r = length(pos);
				float schwarzschild_radius = 1.0;
				if (r > schwarzschild_radius) {
					float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
					float redshift_factor = 1.0 / z_plus_one;
					float wavelength_shift = (z_plus_one - 1.0) * gravitational_redshift_strength;
					
					isco_glow.r *= (1.0 + wavelength_shift * 0.8);
					isco_glow.g *= (1.0 - wavelength_shift * 0.1);
					isco_glow.b *= (1.0 - wavelength_shift * 1.2);
					
					float energy_loss = pow(redshift_factor, 2.0);
					isco_glow *= energy_loss;
				}
			}
			
			if (intensity > 0.01) {
				color += isco_glow * alpha * 0.15;
				alpha *= 0.85;
			}
		}
	}
}

void calculate_hawking_radiation_contribution(vec3 pos, inout vec3 color, float cam_dist) {
	if (hawking_enabled < 0.5 || hawking_intensity < 0.01) {
		return;
	}
	
	float event_horizon = 1.0;
	float dist_to_center = length(pos);
	
	if (dist_to_center < event_horizon * 1.5 && dist_to_center > event_horizon * 0.95) {
		float flash_time = time * hawking_frequency;
		float flash_noise = simplex_noise_3d(vec3(pos.xy * 10.0, flash_time)) * 0.5 + 0.5;
		float flash_pulse = sin(flash_time * TAU) * 0.5 + 0.5;
		flash_pulse = pow(flash_pulse, 3.0);
		
		float proximity = smoothstep(event_horizon * 1.5, event_horizon, dist_to_center);
		float flash_strength = flash_noise * flash_pulse * proximity * hawking_intensity;
		
		if (flash_strength > 0.001) {
			vec3 hawking_glow = vec3(1.0, 0.9, 0.7) * flash_strength * 0.01;
			color += hawking_glow;
		}
	}
}

bool ray_box_intersection(vec3 ray_origin, vec3 ray_dir, vec3 box_center, vec3 box_size, 
                           out float t_hit, out vec3 normal) {
	vec3 box_min = box_center - box_size * 0.5;
	vec3 box_max = box_center + box_size * 0.5;
	
	vec3 inv_dir = 1.0 / (ray_dir + vec3(0.000001));
	vec3 t0 = (box_min - ray_origin) * inv_dir;
	vec3 t1 = (box_max - ray_origin) * inv_dir;
	
	vec3 t_min = min(t0, t1);
	vec3 t_max = max(t0, t1);
	
	float t_near = max(max(t_min.x, t_min.y), t_min.z);
	float t_far = min(min(t_max.x, t_max.y), t_max.z);
	
	if (t_far < t_near || t_far < 0.0) {
		return false;
	}
	
	t_hit = t_near > 0.0 ? t_near : t_far;
	
	vec3 hit_point = ray_origin + ray_dir * t_hit;
	vec3 local_hit = hit_point - box_center;
	vec3 abs_local = abs(local_hit);
	vec3 half_size = box_size * 0.5;
	
	vec3 dist_to_face = abs_local - half_size;
	float max_dist = max(max(dist_to_face.x, dist_to_face.y), dist_to_face.z);
	
	normal = vec3(0.0);
	if (abs(dist_to_face.x - max_dist) < 0.0001) {
		normal = vec3(sign(local_hit.x), 0.0, 0.0);
	} else if (abs(dist_to_face.y - max_dist) < 0.0001) {
		normal = vec3(0.0, sign(local_hit.y), 0.0);
	} else {
		normal = vec3(0.0, 0.0, sign(local_hit.z));
	}
	
	return true;
}

void perform_ray_tracing(vec3 pos, vec3 dir, vec3 cam_pos, inout vec3 color, inout float alpha, out vec3 final_dir, out bool hit_event_horizon, float lensing_strength, float physics_decay) {
	hit_event_horizon = false;
	final_dir = dir;

	float camera_distance = length(pos);
	float STEP_SIZE = max(0.05, camera_distance * 0.008);
	vec3 step_dir = dir * STEP_SIZE;

	vec3 h = cross(pos, step_dir);
	float h2 = dot(h, h);

	bool cube_hit = false;
	float cube_dist = INFINITY;
	
	int loop_count = secondary_images_enabled > 0.5 ? max_ray_loops : 500;

	for (int i = 0; i < loop_count; i++) {
		if (lensing_strength > 0.0 && gravitational_lensing > 0.5) {
			vec3 acc = calculate_gravitational_acceleration(h2, pos) * lensing_strength;
			step_dir += acc;
		}

		float r_squared = dot(pos, pos);
		
		if (r_squared < 1.0) {
			hit_event_horizon = true;
			return;
		}

		if (adisk_enabled > 0.5) {
			calculate_accretion_disk_contribution(pos, cam_pos, color, alpha, physics_decay);
		}
		
		calculate_corona_contribution(pos, color, alpha);
		calculate_isco_ring_contribution(pos, color, alpha);
		calculate_photon_sphere_contribution(pos, color, alpha);
		calculate_jet_contribution(pos, color, alpha);
		calculate_hawking_radiation_contribution(pos, color, camera_distance);
		
		if (cube_enabled > 0.5 && cube_emission_strength > 0.01 && !cube_hit && alpha > 0.01) {
			vec3 current_dir = normalize(step_dir);
			float t_hit;
			vec3 cube_normal;
			
			if (ray_box_intersection(pos, current_dir, cube_position, cube_size, t_hit, cube_normal)) {
				if (t_hit < length(step_dir) * 2.0) {
					cube_hit = true;
					vec3 hit_point = pos + current_dir * t_hit;
					vec3 emission = cube_color * cube_emission_strength;
					float face_intensity = abs(dot(cube_normal, vec3(0.577)));
					face_intensity = 0.6 + face_intensity * 0.4;
					vec3 to_center = hit_point - cube_position;
					vec2 uv_on_face;
					
					if (abs(cube_normal.x) > 0.5) {
						uv_on_face = to_center.yz / cube_size.yz;
					} else if (abs(cube_normal.y) > 0.5) {
						uv_on_face = to_center.xz / cube_size.xz;
					} else {
						uv_on_face = to_center.xy / cube_size.xy;
					}
					
					vec2 grid_uv = fract(uv_on_face * 2.0);
					float grid_line = 0.05;
					float grid = min(
						min(smoothstep(grid_line, 0.0, grid_uv.x), smoothstep(grid_line, 0.0, 1.0 - grid_uv.x)),
						min(smoothstep(grid_line, 0.0, grid_uv.y), smoothstep(grid_line, 0.0, 1.0 - grid_uv.y))
					);
					
					float edge_dist = max(abs(uv_on_face.x), abs(uv_on_face.y));
					float edge_glow = smoothstep(0.4, 0.5, edge_dist);
					vec3 final_emission = emission * face_intensity * (1.0 + edge_glow * 0.3);
					final_emission += emission * grid * 0.5;
					
					if (gravitational_redshift_enabled > 0.5) {
						float r = length(hit_point);
						float schwarzschild_radius = 1.0;
						if (r > schwarzschild_radius) {
							float z_plus_one = 1.0 / sqrt(1.0 - schwarzschild_radius / r);
							float redshift_factor = 1.0 / z_plus_one;
							float wavelength_shift = (z_plus_one - 1.0) * gravitational_redshift_strength;
							
							final_emission.r *= (1.0 + wavelength_shift * 0.8);
							final_emission.g *= (1.0 - wavelength_shift * 0.1);
							final_emission.b *= (1.0 - wavelength_shift * 1.2);
							
							float energy_loss = pow(redshift_factor, 2.0);
							final_emission *= energy_loss;
						}
					}
					
					color += final_emission * alpha;
					alpha = 0.0;
					final_dir = normalize(step_dir);
					return;
				}
			}
		}

		pos += step_dir;
	}

	final_dir = normalize(step_dir);
}

void fragment() {
	mat3 view;
	vec3 camera_pos;
	
	if (use_3d_camera > 0.5) {
		camera_pos = camera_position;
		view = mat3(camera_right, camera_up, camera_forward);
	} else if (mouse_control > 0.5) {
		vec2 mouse = clamp(vec2(mouse_x, mouse_y), 0.0, 1.0);
		float orbit_radius = 15.0;
		float theta = mouse.x * TAU;
		float phi = (mouse.y - 0.5) * PI;
		
		float cos_phi = cos(phi);
		camera_pos = vec3(
			cos(theta) * cos_phi * orbit_radius,
			sin(phi) * orbit_radius,
			sin(theta) * cos_phi * orbit_radius
		);
		
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = calculate_look_at_matrix(camera_pos, target, radians(camera_roll));
	} else if (front_view > 0.5) {
		camera_pos = vec3(10.0, 1.0, 10.0);
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = calculate_look_at_matrix(camera_pos, target, radians(camera_roll));
	} else if (top_view > 0.5) {
		camera_pos = vec3(15.0, 15.0, 0.0);
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = calculate_look_at_matrix(camera_pos, target, radians(camera_roll));
	} else {
		float orbit_radius = 15.0;
		float angle_h = time * 0.1;
		float angle_v = time * 0.15;
		camera_pos = vec3(
			cos(angle_h) * orbit_radius,
			sin(angle_v) * 0.0,
			sin(angle_h) * orbit_radius
		);
		
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = calculate_look_at_matrix(camera_pos, target, radians(camera_roll));
	}

	vec2 uv = SCREEN_UV - vec2(0.5);
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	uv.x *= aspect_ratio;

	vec3 pos = camera_pos;
	vec3 dir;
	
	if (use_3d_camera > 0.5) {
		float fov_rad = radians(camera_fov);
		float tan_half_fov = tan(fov_rad * 0.5);
		
		vec3 dir_local = normalize(vec3(-uv.x * tan_half_fov, uv.y * tan_half_fov, 1.0));
		dir = normalize(dir_local.x * camera_right + dir_local.y * camera_up + dir_local.z * camera_forward);
	} else {
		vec3 dir_local = normalize(vec3(-uv.x * fov_scale, uv.y * fov_scale, 1.0));
		dir = view * dir_local;
	}

	bool skip_post_processing = false;
	
	if (render_black_hole < 0.5) {
		COLOR.rgb = texture(background_texture, SCREEN_UV).rgb;
		COLOR.a = 1.0;
		skip_post_processing = true;
	} else if (lod_level >= 5.0) {
		vec3 blackhole_pos = vec3(0.0, 0.0, 0.0);
		vec3 to_blackhole = blackhole_pos - camera_pos;
		
		float fade_start = 5000.0;
		float fade_end = 20000.0;
		float distance_fade = 1.0 - smoothstep(fade_start, fade_end, distance_to_blackhole);
		
		if (distance_fade > 0.0) {
			float fov_rad = radians(camera_fov);
			float tan_half_fov = tan(fov_rad * 0.5);
			
			vec3 bh_cam_space;
			bh_cam_space.x = dot(to_blackhole, camera_right);
			bh_cam_space.y = dot(to_blackhole, camera_up);
			bh_cam_space.z = dot(to_blackhole, camera_forward);
			
			if (bh_cam_space.z > 0.0) {
				vec2 bh_screen = vec2(-bh_cam_space.x / bh_cam_space.z / tan_half_fov, 
				                       bh_cam_space.y / bh_cam_space.z / tan_half_fov);
				bh_screen.x /= aspect_ratio;
				bh_screen += vec2(0.5);
				
				float dist_to_center = length(SCREEN_UV - bh_screen);
				float pixel_threshold = 0.0008;
				
				if (dist_to_center < pixel_threshold) {
					float point_brightness = 1.0 - smoothstep(0.0, pixel_threshold, dist_to_center);
					COLOR.rgb = vec3(1.0, 0.9, 0.8) * point_brightness * 5.0 * distance_fade;
					COLOR.a = 1.0;
				} else {
					COLOR.rgb = texture(background_texture, SCREEN_UV).rgb;
					COLOR.a = 1.0;
				}
			} else {
				COLOR.rgb = texture(background_texture, SCREEN_UV).rgb;
				COLOR.a = 1.0;
			}
		} else {
			COLOR.rgb = texture(background_texture, SCREEN_UV).rgb;
			COLOR.a = 1.0;
		}
		
		skip_post_processing = true;
	} else {
		vec3 blackhole_pos = vec3(0.0, 0.0, 0.0);
		vec3 to_blackhole = blackhole_pos - camera_pos;
		float dist_to_blackhole = length(to_blackhole);
		float lensing_strength = 0.0;
		
		float schwarzschild_radius = 1.0;
		float strength_factor = max(1.0, gravity_strength);
		float lensing_fade_radius = 2.0 * schwarzschild_radius * strength_factor;
		
		if (auto_fade_lensing < 0.5) {
			lensing_strength = 1.0;
		} else if (use_3d_camera > 0.5) {
			vec3 bh_cam;
			bh_cam.x = dot(to_blackhole, camera_right);
			bh_cam.y = dot(to_blackhole, camera_up);
			bh_cam.z = dot(to_blackhole, camera_forward);
			
			if (bh_cam.z > 0.0) {
				float fov_rad = radians(camera_fov);
				float tan_half_fov = tan(fov_rad * 0.5);
				vec2 bh_screen = vec2(-bh_cam.x / bh_cam.z / tan_half_fov, bh_cam.y / bh_cam.z / tan_half_fov);
				bh_screen.x /= aspect_ratio;
				bh_screen += vec2(0.5);
				
				float angular_radius = atan(lensing_fade_radius / bh_cam.z);
				float screen_radius = angular_radius / tan_half_fov;
				screen_radius /= aspect_ratio;
				
				vec2 closest_point_on_screen = clamp(bh_screen, vec2(0.0), vec2(1.0));
				float dist_center_to_screen = length(bh_screen - closest_point_on_screen);
				float edge_dist_outside = dist_center_to_screen - screen_radius;
				float fade_distance = screen_radius;
				float normalized_dist = clamp(edge_dist_outside / fade_distance, 0.0, 1.0);
				lensing_strength = 1.0 - (normalized_dist * normalized_dist);
			}
		} else {
			vec3 cam_forward = view[2];
			vec3 to_bh_normalized = normalize(to_blackhole);
			float cos_angle = dot(to_bh_normalized, cam_forward);
			float angular_radius = atan(lensing_fade_radius / max(dist_to_blackhole, 0.1));
			float angle_to_bh = acos(clamp(cos_angle, -1.0, 1.0));
			float fov_rad = radians(camera_fov);
			float half_fov = fov_rad * 0.5;
			float edge_angle_outside = angle_to_bh - angular_radius - half_fov;
			float fade_angle = angular_radius;
			float normalized_angle = clamp(edge_angle_outside / fade_angle, 0.0, 1.0);
			lensing_strength = 1.0 - (normalized_angle * normalized_angle);
		}
		
		float gravity_decay = 1.0 - smoothstep(0.0, 5000.0, distance_to_blackhole);
		float lod_lensing_strength = lensing_strength * gravity_decay;
		
		float physics_decay = 1.0;
		if (distance_to_blackhole > 1000.0) {
			physics_decay = 1.0 - smoothstep(1000.0, 4000.0, distance_to_blackhole);
		}
		
		vec3 color = vec3(0.0);
		float alpha = 1.0;
		vec3 final_dir;
		bool hit_event_horizon;
		
		perform_ray_tracing(pos, dir, camera_pos, color, alpha, final_dir, hit_event_horizon, lod_lensing_strength, physics_decay);
		
		if (hit_event_horizon) {
			COLOR.rgb = color;
			COLOR.a = 1.0;
		} else {
			vec2 distorted_uv;
			if (use_3d_camera > 0.5) {
				float fov_rad = radians(camera_fov);
				float tan_half_fov = tan(fov_rad * 0.5);
				vec3 dir_cam;
				dir_cam.x = dot(final_dir, camera_right);
				dir_cam.y = dot(final_dir, camera_up);
				dir_cam.z = dot(final_dir, camera_forward);
				distorted_uv = vec2(-dir_cam.x / dir_cam.z / tan_half_fov, dir_cam.y / dir_cam.z / tan_half_fov);
				distorted_uv.x /= aspect_ratio;
				distorted_uv += vec2(0.5);
			} else {
				vec3 final_dir_camera = transpose(view) * final_dir;
				distorted_uv = vec2(-final_dir_camera.x / final_dir_camera.z, final_dir_camera.y / final_dir_camera.z);
				distorted_uv /= fov_scale;
				distorted_uv.x /= aspect_ratio;
				distorted_uv += vec2(0.5);
			}
			
			vec3 bg_color = texture(background_texture, distorted_uv).rgb;
			
			bg_color = inverse_hdr_pipeline(bg_color);
			
			bg_color = (bg_color - 0.5) / contrast + 0.5;
			bg_color = bg_color / brightness;
			bg_color = clamp(bg_color, 0.0, 1.0);
			
			color += bg_color * alpha;
			
			COLOR.rgb = color;
			COLOR.a = 1.0;
		}
	}
	
	if (!skip_post_processing && render_black_hole >= 0.5) {
		COLOR.rgb = apply_hdr_pipeline(COLOR.rgb);
		
		COLOR.rgb = (COLOR.rgb - 0.5) * contrast + 0.5;
		COLOR.rgb *= brightness;
		COLOR.rgb = clamp(COLOR.rgb, 0.0, 1.0);
	}
}
