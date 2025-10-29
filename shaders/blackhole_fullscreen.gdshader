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

uniform float adisk_enabled : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_particle : hint_range(0.0, 1.0) = 1.0;
uniform float adisk_height : hint_range(0.1, 1.0) = 0.5;
uniform float adisk_lit : hint_range(0.0001, 0.001, 0.0001) = 0.0001;
uniform float adisk_density_v : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_density_h : hint_range(0.1, 3.0) = 1.0;
uniform float adisk_noise_scale : hint_range(0.1, 5.0) = 1.0;
uniform float adisk_noise_lod : hint_range(1.0, 10.0) = 5.0;
uniform float adisk_speed : hint_range(0.0, 2.0) = 0.5;

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

void adisk_color(vec3 pos, inout vec3 color, inout float alpha) {
	float inner_radius = 2.6;
	float outer_radius = 12.0;

	float density = max(0.0, 1.0 - length(pos.xyz / vec3(outer_radius, adisk_height, outer_radius)));
	if (density < 0.001) {
		return;
	}

	density *= pow(1.0 - abs(pos.y) / adisk_height, adisk_density_v);
	density *= smoothstep(inner_radius, inner_radius * 1.1, length(pos));

	if (density < 0.001) {
		return;
	}

	vec3 spherical_coord = to_spherical(pos);
	spherical_coord.y *= 2.0;
	spherical_coord.z *= 4.0;

	density *= 1.0 / pow(spherical_coord.x, adisk_density_h);
	density *= 16000.0;

	if (adisk_particle < 0.5) {
		color += vec3(0.0, 1.0, 0.0) * density * 0.02;
		return;
	}

	float noise = 0.0;
	float amplitude = 1.0;
	float total_amplitude = 0.0;
	vec3 coord = spherical_coord;
	
	for (int i = 0; i < int(adisk_noise_lod); i++) {
		float frequency = pow(2.0, float(i)) * adisk_noise_scale;
		float n = snoise(coord * frequency) * 0.5 + 0.5;
		noise += n * amplitude;
		total_amplitude += amplitude;
		amplitude *= 0.5;
		
		if (i % 2 == 0) {
			coord.y += time * adisk_speed;
		} else {
			coord.y -= time * adisk_speed;
		}
	}
	
	noise /= total_amplitude;

	vec3 dust_color = texture(color_map, vec2(spherical_coord.x / outer_radius, 0.5)).rgb;
	color += density * adisk_lit * dust_color * alpha * noise;
}

void trace_ray(vec3 pos, vec3 dir, inout vec3 color, inout float alpha, out vec3 final_dir, out bool hit_event_horizon) {
	hit_event_horizon = false;
	final_dir = dir;

	float camera_distance = length(pos);
	float STEP_SIZE = max(0.05, camera_distance * 0.008);
	vec3 step_dir = dir * STEP_SIZE;

	vec3 h = cross(pos, step_dir);
	float h2 = dot(h, h);

	for (int i = 0; i < 500; i++) {
		if (gravitational_lensing > 0.5) {
			vec3 acc = accel(h2, pos);
			step_dir += acc;
		}

		if (dot(pos, pos) < 1.0) {
			hit_event_horizon = true;
			return;
		}

		if (adisk_enabled > 0.5) {
			adisk_color(pos, color, alpha);
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
		vec3 color = vec3(0.0);
		float alpha = 1.0;
		vec3 final_dir;
		bool hit_event_horizon;
		
		trace_ray(pos, dir, color, alpha, final_dir, hit_event_horizon);
		
		if (hit_event_horizon) {
			COLOR.rgb = color;
			COLOR.a = 1.0;
		} else {
			vec3 final_dir_camera = transpose(view) * final_dir;
			
			vec2 distorted_uv = vec2(-final_dir_camera.x / final_dir_camera.z, final_dir_camera.y / final_dir_camera.z);
			distorted_uv /= fov_scale;
			distorted_uv.x /= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
			distorted_uv += vec2(0.5);
			
			vec3 bg_color = texture(background_texture, distorted_uv).rgb;
			color += bg_color * alpha;
			
			COLOR.rgb = color;
			COLOR.a = 1.0;
		}
	}
}
