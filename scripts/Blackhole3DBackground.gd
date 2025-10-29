extends Node3D

@onready var camera = $Camera3D
@onready var background_camera = $BackgroundCamera
@onready var fullscreen_quad = $UI/FullscreenQuad
@onready var shader_material = fullscreen_quad.material as ShaderMaterial

@onready var gravitational_lensing_check = $UI/VBoxContainer/CheckBox
@onready var render_black_hole_check = $UI/VBoxContainer/CheckBox2
@onready var adisk_check = $UI/VBoxContainer/CheckBox3
@onready var gravity_slider = $UI/VBoxContainer/HSlider
@onready var gravity_label = $UI/VBoxContainer/Label2
@onready var adisk_height_slider = $UI/VBoxContainer/HSlider2
@onready var adisk_height_label = $UI/VBoxContainer/Label3
@onready var adisk_lit_slider = $UI/VBoxContainer/HSlider3
@onready var adisk_lit_label = $UI/VBoxContainer/Label4

var camera_speed = 8.0
var mouse_sensitivity = 0.002
var camera_rotation = Vector2.ZERO
var mouse_captured = false

var time_elapsed = 0.0
var background_viewport: Viewport
var background_texture: ViewportTexture

func _ready():
	gravitational_lensing_check.toggled.connect(_on_gravitational_lensing_toggled)
	render_black_hole_check.toggled.connect(_on_render_black_hole_toggled)
	adisk_check.toggled.connect(_on_adisk_toggled)
	gravity_slider.value_changed.connect(_on_gravity_changed)
	adisk_height_slider.value_changed.connect(_on_adisk_height_changed)
	adisk_lit_slider.value_changed.connect(_on_adisk_lit_changed)
	
	gravitational_lensing_check.button_pressed = true
	render_black_hole_check.button_pressed = true
	adisk_check.button_pressed = true
	
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
	
	var nodes_to_move = []
	for child in get_children():
		if child == camera or child == background_camera or child is Control:
			continue
		if child is Node3D or child is WorldEnvironment:
			nodes_to_move.append(child)
	
	for node in nodes_to_move:
		node.reparent(background_viewport)
	
	add_child(background_viewport)
	background_texture = background_viewport.get_texture()
	shader_material.set_shader_parameter("background_texture", background_texture)


func _process(delta):
	time_elapsed += delta
	if shader_material:
		shader_material.set_shader_parameter("time", time_elapsed)
		update_shader_camera()
	
	handle_camera_movement(delta)
	
	if background_camera and camera:
		background_camera.global_transform = camera.global_transform
		background_camera.fov = camera.fov

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
