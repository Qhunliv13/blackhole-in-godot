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
uniform float gravity_strength : hint_range(0.01, 2.0) = 0.15;
uniform float render_black_hole : hint_range(0.0, 1.0) = 1.0;
uniform float mouse_control : hint_range(0.0, 1.0) = 0.0;
uniform float fov_scale : hint_range(0.1, 3.0) = 1.0;
uniform float auto_fade_lensing : hint_range(0.0, 1.0) = 1.0;

uniform float adisk_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_particle : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_height : hint_range(0.1, 1.0) = 0.5;
uniform float adisk_lit : hint_range(0.0001, 0.001, 0.0001) = 0.0001;
uniform float adisk_density_v : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_density_h : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_noise_scale : hint_range(0.1, 5.0) = 1.0;
uniform float adisk_noise_lod : hint_range(1.0, 10.0) = 5.0;
uniform float adisk_speed : hint_range(0.0, 2.0) = 0.5;
uniform float adisk_inner_radius : hint_range(1.0, 5.0) = 2.6;
uniform float adisk_outer_radius : hint_range(5.0, 20.0) = 12.0;

uniform float cube_enabled : hint_range(0.0, 1.0) = 1.0;
uniform vec3 cube_position = vec3(3.0, 0.0, 0.0);
uniform vec3 cube_size = vec3(1.0, 1.0, 1.0);
uniform vec3 cube_color = vec3(0.4, 0.8, 1.0);
uniform float cube_emission_strength : hint_range(0.1, 10.0) = 2.0;

uniform float doppler_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float doppler_strength : hint_range(0.0, 2.0) = 0.8;
uniform float beaming_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float beaming_strength : hint_range(1.0, 5.0) = 3.0;

struct Ring {
	vec3 center;
	vec3 normal;
	float inner_radius;
	float outer_radius;
	float rotate_speed;
};

vec4 permute(vec4 x) { 
	return mod(((x * 34.0) + 1.0) * x, 289.0); 
}

vec4 taylorInvSqrt(vec4 r) { 
	return 1.79284291400159 - 0.85373472095314 * r; 
}

float snoise(vec3 v) {
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

vec3 accel(float h2, vec3 pos) {
	float r2 = dot(pos, pos);
	float r5 = pow(r2, 2.5);
	vec3 acc = -1.5 * h2 * pos / r5 * gravity_strength;
	return acc;
}

vec4 quad_from_axis_angle(vec3 axis, float angle) {
	vec4 qr;
	float half_angle = (angle * 0.5) * 3.14159 / 180.0;
	qr.x = axis.x * sin(half_angle);
	qr.y = axis.y * sin(half_angle);
	qr.z = axis.z * sin(half_angle);
	qr.w = cos(half_angle);
	return qr;
}

vec4 quad_conj(vec4 q) { 
	return vec4(-q.x, -q.y, -q.z, q.w); 
}

vec4 quat_mult(vec4 q1, vec4 q2) {
	vec4 qr;
	qr.x = (q1.w * q2.x) + (q1.x * q2.w) + (q1.y * q2.z) - (q1.z * q2.y);
	qr.y = (q1.w * q2.y) - (q1.x * q2.z) + (q1.y * q2.w) + (q1.z * q2.x);
	qr.z = (q1.w * q2.z) + (q1.x * q2.y) - (q1.y * q2.x) + (q1.z * q2.w);
	qr.w = (q1.w * q2.w) - (q1.x * q2.x) - (q1.y * q2.y) - (q1.z * q2.z);
	return qr;
}

vec3 rotate_vector(vec3 position, vec3 axis, float angle) {
	vec4 qr = quad_from_axis_angle(axis, angle);
	vec4 qr_conj = quad_conj(qr);
	vec4 q_pos = vec4(position.x, position.y, position.z, 0);

	vec4 q_tmp = quat_mult(qr, q_pos);
	qr = quat_mult(q_tmp, qr_conj);

	return vec3(qr.x, qr.y, qr.z);
}

vec3 to_spherical(vec3 p) {
	float rho = sqrt((p.x * p.x) + (p.y * p.y) + (p.z * p.z));
	float theta = atan(p.z, p.x);
	float phi = asin(p.y / rho);
	return vec3(rho, theta, phi);
}

mat3 look_at(vec3 origin, vec3 target, float roll) {
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

void adisk_color(vec3 pos, vec3 cam_pos, inout vec3 color, inout float alpha) {
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
	float angular_velocity = 1.0 / sqrt(max(normalized_radius, 0.5));
	
	float rotation_angle = time * adisk_speed * angular_velocity;
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
		
		float n = snoise(layer_rotated * frequency) * 0.5 + 0.5;
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
	float detail = snoise(detail_pos * adisk_noise_scale * 16.0) * 0.5 + 0.5;
	noise = mix(noise, detail, 0.3);

	vec3 dust_color = texture(color_map, vec2(radial_dist / outer_radius, 0.5)).rgb;
	
	if (doppler_enabled > 0.5) {
		vec3 radial_dir = normalize(vec3(disk_pos.x, 0.0, disk_pos.z));
		vec3 tangent_dir = vec3(-radial_dir.z, 0.0, radial_dir.x);
		if (adisk_speed < 0.0) {
			tangent_dir = -tangent_dir;
		}
		
		float orbital_speed = angular_velocity * radial_dist;
		float beta = orbital_speed * abs(adisk_speed) * 0.15;
		beta = clamp(beta, 0.0, 0.5);
		
		vec3 velocity = tangent_dir * beta;
		vec3 view_dir = normalize(cam_pos - pos);
		float cos_theta = dot(normalize(velocity), view_dir);
		float radial_velocity = beta * cos_theta;
		float doppler_shift = radial_velocity * doppler_strength;
		
		if (doppler_shift > 0.0) {
			dust_color.r *= (1.0 - doppler_shift * 0.5);
			dust_color.g *= (1.0 - doppler_shift * 0.2);
			dust_color.b *= (1.0 + doppler_shift * 1.5);
		} else {
			float red_shift = -doppler_shift;
			dust_color.r *= (1.0 + red_shift * 1.5);
			dust_color.g *= (1.0 - red_shift * 0.2);
			dust_color.b *= (1.0 - red_shift * 0.5);
		}
		
		if (beaming_enabled > 0.5) {
			float beta_sq = beta * beta;
			float gamma = 1.0 / sqrt(max(1.0 - beta_sq, 0.01));
			float doppler_factor = 1.0 / (gamma * (1.0 - beta * cos_theta));
			float beaming_boost = pow(max(doppler_factor, 0.1), beaming_strength);
			beaming_boost = clamp(beaming_boost, 0.1, 10.0);
			dust_color *= beaming_boost;
		} else {
			float brightness_factor = 1.0 + doppler_shift * 0.5;
			dust_color *= brightness_factor;
		}
	}
	
	color += density * adisk_lit * dust_color * alpha * noise;
}

bool intersect_cube(vec3 ray_origin, vec3 ray_dir, vec3 box_center, vec3 box_size, 
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

void trace_ray(vec3 pos, vec3 dir, vec3 cam_pos, inout vec3 color, inout float alpha, out vec3 final_dir, out bool hit_event_horizon, float lensing_strength) {
	hit_event_horizon = false;
	final_dir = dir;

	float camera_distance = length(pos);
	float STEP_SIZE = max(0.05, camera_distance * 0.008);
	vec3 step_dir = dir * STEP_SIZE;

	vec3 h = cross(pos, step_dir);
	float h2 = dot(h, h);
	
	bool cube_hit = false;
	float cube_dist = INFINITY;

	for (int i = 0; i < 500; i++) {
		if (lensing_strength > 0.0 && gravitational_lensing > 0.5) {
			vec3 acc = accel(h2, pos) * lensing_strength;
			step_dir += acc;
		}

		if (dot(pos, pos) < 1.0) {
			hit_event_horizon = true;
			return;
		}

		if (adisk_enabled > 0.5) {
			adisk_color(pos, cam_pos, color, alpha);
		}
		
		if (cube_enabled > 0.5 && !cube_hit && alpha > 0.01) {
			vec3 current_dir = normalize(step_dir);
			float t_hit;
			vec3 cube_normal;
			
			if (intersect_cube(pos, current_dir, cube_position, cube_size, t_hit, cube_normal)) {
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
		float theta = mouse.x * 6.28318;
		float phi = (mouse.y - 0.5) * 3.14159;
		
		float cos_phi = cos(phi);
		camera_pos = vec3(
			cos(theta) * cos_phi * orbit_radius,
			sin(phi) * orbit_radius,
			sin(theta) * cos_phi * orbit_radius
		);
		
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = look_at(camera_pos, target, radians(camera_roll));
	} else if (front_view > 0.5) {
		camera_pos = vec3(10.0, 1.0, 10.0);
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = look_at(camera_pos, target, radians(camera_roll));
	} else if (top_view > 0.5) {
		camera_pos = vec3(15.0, 15.0, 0.0);
		vec3 target = vec3(0.0, 0.0, 0.0);
		view = look_at(camera_pos, target, radians(camera_roll));
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
		view = look_at(camera_pos, target, radians(camera_roll));
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

	if (render_black_hole < 0.5) {
		COLOR.rgb = texture(background_texture, SCREEN_UV).rgb;
		COLOR.a = 1.0;
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
		
		vec3 color = vec3(0.0);
		float alpha = 1.0;
		vec3 final_dir;
		bool hit_event_horizon;
		
		trace_ray(pos, dir, camera_pos, color, alpha, final_dir, hit_event_horizon, lensing_strength);
		
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
			color += bg_color * alpha;
			
			COLOR.rgb = color;
			COLOR.a = 1.0;
		}
	}
}
