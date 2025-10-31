extends Node3D

@onready var camera = $Camera3D
@onready var background_camera = $BackgroundCamera
@onready var foward_camera = $fowardCamera
@onready var fullscreen_quad = $UI/FullscreenQuad
@onready var foreground_rect = $UI/ForegroundRect
@onready var shader_material = fullscreen_quad.material as ShaderMaterial

@onready var gravitational_lensing_check = $UI/VBoxContainer/CheckBox
@onready var render_black_hole_check = $UI/VBoxContainer/CheckBox2
@onready var adisk_check = $UI/VBoxContainer/CheckBox3
@onready var auto_fade_lensing_check = $UI/VBoxContainer/CheckBox4
@onready var gravity_slider = $UI/VBoxContainer/HSlider
@onready var gravity_label = $UI/VBoxContainer/Label2
@onready var adisk_height_slider = $UI/VBoxContainer/HSlider2
@onready var adisk_height_label = $UI/VBoxContainer/Label3
@onready var adisk_lit_slider = $UI/VBoxContainer/HSlider3
@onready var adisk_lit_label = $UI/VBoxContainer/Label4
@onready var adisk_inner_radius_slider = $UI/VBoxContainer/HSlider4
@onready var adisk_inner_radius_label = $UI/VBoxContainer/Label5
@onready var adisk_outer_radius_slider = $UI/VBoxContainer/HSlider5
@onready var adisk_outer_radius_label = $UI/VBoxContainer/Label6
@onready var cube_check = $UI/VBoxContainer/CheckBox5
@onready var cube_emission_slider = $UI/VBoxContainer/HSlider6
@onready var cube_emission_label = $UI/VBoxContainer/Label7
@onready var doppler_check = $UI/VBoxContainer/CheckBox6
@onready var doppler_slider = $UI/VBoxContainer/HSlider7
@onready var doppler_label = $UI/VBoxContainer/Label8
@onready var beaming_check = $UI/VBoxContainer/CheckBox7
@onready var beaming_slider = $UI/VBoxContainer/HSlider8
@onready var beaming_label = $UI/VBoxContainer/Label9

var camera_speed = 8.0
var mouse_sensitivity = 0.002
var camera_rotation = Vector2.ZERO
var mouse_captured = false

var time_elapsed = 0.0
var background_viewport: Viewport
var background_texture: ViewportTexture
var background_nodes: Array = []
var foreground_viewport: SubViewport
var foreground_texture: ViewportTexture
var node_original_layers: Dictionary = {}
var node_is_foreground: Dictionary = {}
var node_filtered_s: Dictionary = {}
var adisk_outer_radius_value: float = 12.0
var blackhole_position := Vector3.ZERO
const BACK_LAYER := 1 << 1
const FRONT_LAYER := 1 << 2

func _ready():
	gravitational_lensing_check.toggled.connect(_on_gravitational_lensing_toggled)
	render_black_hole_check.toggled.connect(_on_render_black_hole_toggled)
	adisk_check.toggled.connect(_on_adisk_toggled)
	auto_fade_lensing_check.toggled.connect(_on_auto_fade_lensing_toggled)
	gravity_slider.value_changed.connect(_on_gravity_changed)
	adisk_height_slider.value_changed.connect(_on_adisk_height_changed)
	adisk_lit_slider.value_changed.connect(_on_adisk_lit_changed)
	adisk_inner_radius_slider.value_changed.connect(_on_adisk_inner_radius_changed)
	adisk_outer_radius_slider.value_changed.connect(_on_adisk_outer_radius_changed)
	cube_check.toggled.connect(_on_cube_toggled)
	cube_emission_slider.value_changed.connect(_on_cube_emission_changed)
	doppler_check.toggled.connect(_on_doppler_toggled)
	doppler_slider.value_changed.connect(_on_doppler_changed)
	beaming_check.toggled.connect(_on_beaming_toggled)
	beaming_slider.value_changed.connect(_on_beaming_changed)
	
	gravitational_lensing_check.button_pressed = true
	render_black_hole_check.button_pressed = true
	adisk_check.button_pressed = true
	auto_fade_lensing_check.button_pressed = true
	
	setup_textures()
	setup_background_camera()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func setup_textures():
	var color_map_path = "res://textures/color_map.png"
	if ResourceLoader.exists(color_map_path):
		var color_map = load(color_map_path)
		shader_material.set_shader_parameter("color_map", color_map)

func setup_background_camera():
	var viewport_size = get_viewport().size
	
	background_viewport = SubViewport.new()
	background_viewport.size = viewport_size
	background_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	background_viewport.transparent_bg = false
	
	background_camera.reparent(background_viewport)
	background_camera.current = true
	background_camera.cull_mask = BACK_LAYER
	background_camera.fov = camera.fov
	background_camera.global_transform = camera.global_transform
	
	var nodes_to_move = []
	for child in get_children():
		if child == camera or child == background_camera or child is Control:
			continue
		if child is Node3D or child is WorldEnvironment:
			nodes_to_move.append(child)
	
	for node in nodes_to_move:
		node.reparent(background_viewport)
		if node is VisualInstance3D:
			background_nodes.append(node)
	
	add_child(background_viewport)
	background_texture = background_viewport.get_texture()
	shader_material.set_shader_parameter("background_texture", background_texture)

	if shader_material and shader_material.get_shader_parameter("adisk_outer_radius") != null:
		adisk_outer_radius_value = float(shader_material.get_shader_parameter("adisk_outer_radius"))

	foreground_viewport = SubViewport.new()
	foreground_viewport.size = viewport_size
	foreground_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	foreground_viewport.transparent_bg = true
	add_child(foreground_viewport)

	foreground_viewport.world_3d = background_viewport.world_3d

	foward_camera.reparent(foreground_viewport)
	foward_camera.current = true
	foward_camera.cull_mask = FRONT_LAYER
	foward_camera.fov = camera.fov
	foward_camera.global_transform = camera.global_transform

	foreground_texture = foreground_viewport.get_texture()
	foreground_rect.texture = foreground_texture


func _process(delta):
	time_elapsed += delta
	if shader_material:
		shader_material.set_shader_parameter("time", time_elapsed)
		update_shader_camera()
	
	handle_camera_movement(delta)
	
	if background_camera and camera:
		background_camera.global_transform = camera.global_transform
		background_camera.fov = camera.fov
		update_background_visibility()

	if foward_camera and camera:
		foward_camera.global_transform = camera.global_transform
		foward_camera.fov = camera.fov

func is_object_behind_blackhole(object_pos: Vector3) -> bool:
	var C = camera.global_transform.origin
	var F = -camera.global_transform.basis.z
	var v_bh = blackhole_position - C
	var v_obj = object_pos - C
	var d_bh = v_bh.dot(F)
	var d_obj = v_obj.dot(F)
	if d_bh <= 0.0 or d_obj <= 0.0:
		return false

	var u_bh = v_bh.normalized()
	var u_obj = v_obj.normalized()
	var dot_val = clamp(u_bh.dot(u_obj), -1.0, 1.0)
	var ang = acos(dot_val)
	var theta_bh = atan(adisk_outer_radius_value / d_bh)
	return d_obj > d_bh and ang <= theta_bh

func update_background_visibility():
	var C = camera.global_transform.origin
	var B = blackhole_position
	var L = C - B
	var L_len = L.length()
	if L_len < 0.0001:
		return
	var L_hat = L / L_len
	var eps_base = 0.2 * adisk_outer_radius_value
	var eps_dist = 0.02 * L_len
	var eps = max(0.05, max(eps_base, eps_dist))
	var smoothing_alpha = 0.25
	for n in background_nodes:
		if not (n is VisualInstance3D):
			continue
		var v: VisualInstance3D = n as VisualInstance3D
		var obj_pos = v.global_transform.origin
		var s_raw = (obj_pos - B).dot(L_hat)
		var s_prev: float = node_filtered_s.get(v, s_raw)
		var s_f = lerp(s_prev, s_raw, smoothing_alpha)
		node_filtered_s[v] = s_f

		var default_fg: bool = s_f >= 0.0
		var prev_foreground: bool = node_is_foreground.get(v, default_fg)
		var next_foreground: bool = prev_foreground
		if prev_foreground:
			next_foreground = not (s_f <= -eps)
		else:
			next_foreground = (s_f >= eps)

		node_is_foreground[v] = next_foreground

		if not node_original_layers.has(v):
			node_original_layers[v] = v.layers
		var orig_layers: int = node_original_layers.get(v, v.layers)
		var cleared = orig_layers & ~(BACK_LAYER | FRONT_LAYER)
		var layers: int = cleared
		if next_foreground:
			layers |= FRONT_LAYER
		else:
			layers |= BACK_LAYER
		v.layers = layers
		v.visible = true

func update_shader_camera():
	if camera and shader_material:
		var cam_transform = camera.global_transform
		var cam_pos = cam_transform.origin
		var cam_forward = -cam_transform.basis.z
		var cam_up = -cam_transform.basis.y
		var cam_right = -cam_transform.basis.x
		
		shader_material.set_shader_parameter("camera_position", cam_pos)
		shader_material.set_shader_parameter("camera_forward", cam_forward)
		shader_material.set_shader_parameter("camera_up", cam_up)
		shader_material.set_shader_parameter("camera_right", cam_right)
		shader_material.set_shader_parameter("camera_fov", camera.fov)

func handle_camera_movement(delta):
	if not mouse_captured:
		return
	
	var input_dir = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		input_dir -= camera.global_transform.basis.z
	if Input.is_key_pressed(KEY_S):
		input_dir += camera.global_transform.basis.z
	
	if Input.is_key_pressed(KEY_A):
		input_dir -= camera.global_transform.basis.x
	if Input.is_key_pressed(KEY_D):
		input_dir += camera.global_transform.basis.x
	
	if Input.is_key_pressed(KEY_Q):
		input_dir += Vector3.UP
	if Input.is_key_pressed(KEY_E):
		input_dir += Vector3.DOWN
	
	if Input.is_action_just_pressed("ui_accept"):
		input_dir -= camera.global_transform.basis.z * 3.0
	elif Input.is_action_just_pressed("ui_cancel"):
		input_dir += camera.global_transform.basis.z * 3.0
	
	if input_dir != Vector3.ZERO:
		camera.global_transform.origin += input_dir.normalized() * camera_speed * delta

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			if mouse_captured:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_captured = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				mouse_captured = true
	
	if event is InputEventMouseMotion and mouse_captured:
		camera_rotation.y -= event.relative.x * mouse_sensitivity
		camera_rotation.x -= event.relative.y * mouse_sensitivity
		camera_rotation.x = clamp(camera_rotation.x, -PI/2, PI/2)
		camera.rotation = Vector3(camera_rotation.x, camera_rotation.y, 0)

func _on_gravitational_lensing_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("gravitational_lensing", 1.0 if pressed else 0.0)

func _on_render_black_hole_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("render_black_hole", 1.0 if pressed else 0.0)

func _on_adisk_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("adisk_enabled", 1.0 if pressed else 0.0)

func _on_auto_fade_lensing_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("auto_fade_lensing", 1.0 if pressed else 0.0)

func _on_gravity_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("gravity_strength", value)
		gravity_label.text = "引力强度: %.2f" % value

func _on_adisk_height_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_height", value)
		adisk_height_label.text = "吸积盘高度: %.3f" % value

func _on_adisk_lit_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_lit", value)
		adisk_lit_label.text = "吸积盘亮度: %.5f" % value

func _on_adisk_inner_radius_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_inner_radius", value)
		adisk_inner_radius_label.text = "吸积盘内半径: %.2f" % value

func _on_adisk_outer_radius_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_outer_radius", value)
		adisk_outer_radius_label.text = "吸积盘外半径: %.2f" % value
		adisk_outer_radius_value = value

func _on_cube_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("cube_enabled", 1.0 if pressed else 0.0)

func _on_cube_emission_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("cube_emission_strength", value)
		cube_emission_label.text = "立方体发光强度: %.2f" % value

func _on_doppler_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("doppler_enabled", 1.0 if pressed else 0.0)

func _on_doppler_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("doppler_strength", value)
		doppler_label.text = "多普勒强度: %.2f" % value

func _on_beaming_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("beaming_enabled", 1.0 if pressed else 0.0)

func _on_beaming_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("beaming_strength", value)
		beaming_label.text = "束射强度: %.1f" % value
