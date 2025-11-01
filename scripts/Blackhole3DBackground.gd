extends Node3D

@onready var camera = $Camera3D
@onready var background_camera = $BackgroundCamera
@onready var foward_camera = $fowardCamera
@onready var icon_panel = $UI/IconPanel
@onready var icon_option = $UI/IconPanel/VBox/IconOption
@onready var icon_display = $UI/IconPanel/VBox/IconDisplay
@onready var apply_button = $UI/IconPanel/VBox/ApplyButton
@onready var scroll_container = $UI/ScrollContainer
@onready var fullscreen_quad = $UI/FullscreenQuad
@onready var foreground_rect = $UI/ForegroundRect
@onready var shader_material = fullscreen_quad.material as ShaderMaterial

@onready var gravitational_lensing_check = $UI/ScrollContainer/VBoxContainer/CheckBox
@onready var render_black_hole_check = $UI/ScrollContainer/VBoxContainer/CheckBox2
@onready var adisk_check = $UI/ScrollContainer/VBoxContainer/CheckBox3
@onready var auto_fade_lensing_check = $UI/ScrollContainer/VBoxContainer/CheckBox4
@onready var gravity_slider = $UI/ScrollContainer/VBoxContainer/HSlider
@onready var gravity_label = $UI/ScrollContainer/VBoxContainer/Label2
@onready var adisk_height_slider = $UI/ScrollContainer/VBoxContainer/HSlider2
@onready var adisk_height_label = $UI/ScrollContainer/VBoxContainer/Label3
@onready var adisk_lit_slider = $UI/ScrollContainer/VBoxContainer/HSlider3
@onready var adisk_lit_label = $UI/ScrollContainer/VBoxContainer/Label4
@onready var adisk_inner_radius_slider = $UI/ScrollContainer/VBoxContainer/HSlider4
@onready var adisk_inner_radius_label = $UI/ScrollContainer/VBoxContainer/Label5
@onready var adisk_outer_radius_slider = $UI/ScrollContainer/VBoxContainer/HSlider5
@onready var adisk_outer_radius_label = $UI/ScrollContainer/VBoxContainer/Label6
@onready var cube_check = $UI/ScrollContainer/VBoxContainer/CheckBox5
@onready var cube_emission_slider = $UI/ScrollContainer/VBoxContainer/HSlider6
@onready var cube_emission_label = $UI/ScrollContainer/VBoxContainer/Label7
@onready var doppler_check = $UI/ScrollContainer/VBoxContainer/CheckBox6
@onready var doppler_slider = $UI/ScrollContainer/VBoxContainer/HSlider7
@onready var doppler_label = $UI/ScrollContainer/VBoxContainer/Label8
@onready var beaming_check = $UI/ScrollContainer/VBoxContainer/CheckBox7
@onready var beaming_slider = $UI/ScrollContainer/VBoxContainer/HSlider8
@onready var beaming_label = $UI/ScrollContainer/VBoxContainer/Label9
@onready var jet_check = $UI/ScrollContainer/VBoxContainer/CheckBox8
@onready var jet_slider = $UI/ScrollContainer/VBoxContainer/HSlider9
@onready var jet_label = $UI/ScrollContainer/VBoxContainer/Label10
@onready var jet_rotation_slider = $UI/ScrollContainer/VBoxContainer/HSlider11
@onready var jet_rotation_label = $UI/ScrollContainer/VBoxContainer/Label12
@onready var jet_burst_slider = $UI/ScrollContainer/VBoxContainer/HSlider12
@onready var jet_burst_label = $UI/ScrollContainer/VBoxContainer/Label13
@onready var hawking_check = $UI/ScrollContainer/VBoxContainer/CheckBox9
@onready var hawking_slider = $UI/ScrollContainer/VBoxContainer/HSlider10
@onready var hawking_label = $UI/ScrollContainer/VBoxContainer/Label11
@onready var grav_redshift_check = $UI/ScrollContainer/VBoxContainer/CheckBox10
@onready var grav_redshift_slider = $UI/ScrollContainer/VBoxContainer/HSlider13
@onready var grav_redshift_label = $UI/ScrollContainer/VBoxContainer/Label14
@onready var photon_sphere_check = $UI/ScrollContainer/VBoxContainer/CheckBox11
@onready var photon_sphere_slider = $UI/ScrollContainer/VBoxContainer/HSlider14
@onready var photon_sphere_label = $UI/ScrollContainer/VBoxContainer/Label15
@onready var isco_check = $UI/ScrollContainer/VBoxContainer/CheckBox12
@onready var isco_slider = $UI/ScrollContainer/VBoxContainer/HSlider15
@onready var isco_label = $UI/ScrollContainer/VBoxContainer/Label16
@onready var corona_check = $UI/ScrollContainer/VBoxContainer/CheckBox13
@onready var corona_slider = $UI/ScrollContainer/VBoxContainer/HSlider16
@onready var corona_label = $UI/ScrollContainer/VBoxContainer/Label17
@onready var temperature_check = $UI/ScrollContainer/VBoxContainer/CheckBox14
@onready var qpo_check = $UI/ScrollContainer/VBoxContainer/CheckBox15
@onready var qpo_slider = $UI/ScrollContainer/VBoxContainer/HSlider17
@onready var qpo_label = $UI/ScrollContainer/VBoxContainer/Label18
@onready var secondary_images_check = $UI/ScrollContainer/VBoxContainer/CheckBox16
@onready var frame_dragging_check = $UI/ScrollContainer/VBoxContainer/CheckBox17
@onready var spin_slider = $UI/ScrollContainer/VBoxContainer/HSlider18
@onready var spin_label = $UI/ScrollContainer/VBoxContainer/Label19
@onready var time_dilation_check = $UI/ScrollContainer/VBoxContainer/CheckBox18
@onready var time_dilation_slider = $UI/ScrollContainer/VBoxContainer/HSlider19
@onready var time_dilation_label = $UI/ScrollContainer/VBoxContainer/Label20
@onready var spiral_check = $UI/ScrollContainer/VBoxContainer/CheckBox19
@onready var spiral_count_slider = $UI/ScrollContainer/VBoxContainer/HSlider20
@onready var spiral_count_label = $UI/ScrollContainer/VBoxContainer/Label21
@onready var spiral_strength_slider = $UI/ScrollContainer/VBoxContainer/HSlider21
@onready var spiral_strength_label = $UI/ScrollContainer/VBoxContainer/Label22
@onready var hotspots_check = $UI/ScrollContainer/VBoxContainer/CheckBox20
@onready var hotspots_count_slider = $UI/ScrollContainer/VBoxContainer/HSlider22
@onready var hotspots_count_label = $UI/ScrollContainer/VBoxContainer/Label23
@onready var hotspots_intensity_slider = $UI/ScrollContainer/VBoxContainer/HSlider23
@onready var hotspots_intensity_label = $UI/ScrollContainer/VBoxContainer/Label24
@onready var m87_button = $UI/ScrollContainer/VBoxContainer/M87Button
@onready var sgra_button = $UI/ScrollContainer/VBoxContainer/SgrAButton

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
const MAX_RENDER_DISTANCE := 2000.0
var user_render_black_hole_enabled := true
var current_language := "en"
var ui_texts := {
	"en": {
		"icon_title": "Icon Selection (Press 1)",
		"icon_option_a": "Icon A",
		"icon_option_b": "Icon B",
		"apply_button": "Confirm and Switch (Restart)",
		"blackhole_title": "Black Hole",
		"gravitational_lensing": "Gravitational Lensing",
		"render_blackhole": "Render Black Hole",
		"accretion_disk": "Accretion Disk",
		"auto_fade": "Auto Fade Lensing",
		"gravity_strength": "Gravity Strength",
		"disk_height": "Disk Height",
		"disk_brightness": "Disk Brightness",
		"disk_inner_radius": "Disk Inner Radius",
		"disk_outer_radius": "Disk Outer Radius",
		"emissive_cube": "Emissive Cube",
		"cube_emission": "Cube Emission",
		"doppler_effect": "Doppler Effect",
		"doppler_strength": "Doppler Strength",
		"relativistic_beaming": "Relativistic Beaming",
		"beaming_strength": "Beaming Strength",
		"black_hole_jets": "Black Hole Jets",
		"jet_intensity": "Jet Intensity",
		"jet_rotation": "Jet Rotation",
		"jet_burst": "Jet Burst",
		"hawking_radiation": "Hawking Radiation (Theory)",
		"radiation_intensity": "Radiation Intensity",
		"gravitational_redshift": "Gravitational Redshift",
		"redshift_strength": "Redshift Strength",
		"photon_sphere": "Photon Sphere (Theory)",
		"photon_intensity": "Photon Intensity",
		"isco_ring": "ISCO Ring (Theory)",
		"isco_intensity": "ISCO Intensity",
		"xray_corona": "X-ray Corona (Theory)",
		"corona_intensity": "Corona Intensity",
		"temperature_gradient": "Temperature Gradient",
		"qpo": "Quasi-Periodic Oscillations",
		"qpo_frequency": "QPO Frequency",
		"secondary_images": "Secondary Images (Slow)",
		"frame_dragging": "Frame Dragging (Kerr)",
		"black_hole_spin": "Black Hole Spin",
		"time_dilation": "Time Dilation",
		"dilation_strength": "Dilation Strength",
		"spiral_arms": "Spiral Arms",
		"spiral_count": "Spiral Count",
		"spiral_strength": "Spiral Strength",
		"hot_spots": "Hot Spots",
		"hotspots_count": "Hot Spots Count",
		"hotspots_intensity": "Hot Spots Intensity",
		"preset_title": "Parameter Presets",
		"m87_button": "Set to M87* Parameters",
		"sgra_button": "Set to Sgr A* Parameters"
	},
	"zh": {
		"icon_title": "图标选择 (按1切换)",
		"icon_option_a": "图标 A",
		"icon_option_b": "图标 B",
		"apply_button": "确定并切换（重启）",
		"blackhole_title": "黑洞",
		"gravitational_lensing": "引力透镜效果",
		"render_blackhole": "渲染黑洞",
		"accretion_disk": "吸积盘",
		"auto_fade": "自动衰减透镜",
		"gravity_strength": "引力强度",
		"disk_height": "吸积盘高度",
		"disk_brightness": "吸积盘亮度",
		"disk_inner_radius": "吸积盘内半径",
		"disk_outer_radius": "吸积盘外半径",
		"emissive_cube": "自发光立方体",
		"cube_emission": "立方体发光强度",
		"doppler_effect": "多普勒效应",
		"doppler_strength": "多普勒强度",
		"relativistic_beaming": "相对论束射",
		"beaming_strength": "束射强度",
		"black_hole_jets": "黑洞喷流",
		"jet_intensity": "喷流强度",
		"jet_rotation": "喷流旋转",
		"jet_burst": "喷流爆发",
		"hawking_radiation": "霍金辐射（理论）",
		"radiation_intensity": "辐射强度",
		"gravitational_redshift": "引力红移",
		"redshift_strength": "红移强度",
		"photon_sphere": "光子球（理论）",
		"photon_intensity": "光子球强度",
		"isco_ring": "ISCO内环（理论）",
		"isco_intensity": "ISCO强度",
		"xray_corona": "X射线冕（理论）",
		"corona_intensity": "冕强度",
		"temperature_gradient": "温度梯度",
		"qpo": "准周期振荡",
		"qpo_frequency": "QPO频率",
		"secondary_images": "多重像（慢）",
		"frame_dragging": "帧拖曳（克尔）",
		"black_hole_spin": "黑洞自旋",
		"time_dilation": "时间膨胀",
		"dilation_strength": "膨胀强度",
		"spiral_arms": "螺旋臂",
		"spiral_count": "螺旋臂数",
		"spiral_strength": "螺旋强度",
		"hot_spots": "热点",
		"hotspots_count": "热点数量",
		"hotspots_intensity": "热点强度",
		"preset_title": "参数预设",
		"m87_button": "设置为 M87* 参数",
		"sgra_button": "设置为 Sgr A* 参数"
	}
}

func _ready():
	setup_icon_options()
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
	jet_check.toggled.connect(_on_jet_toggled)
	jet_slider.value_changed.connect(_on_jet_changed)
	jet_rotation_slider.value_changed.connect(_on_jet_rotation_changed)
	jet_burst_slider.value_changed.connect(_on_jet_burst_changed)
	hawking_check.toggled.connect(_on_hawking_toggled)
	hawking_slider.value_changed.connect(_on_hawking_changed)
	grav_redshift_check.toggled.connect(_on_grav_redshift_toggled)
	grav_redshift_slider.value_changed.connect(_on_grav_redshift_changed)
	photon_sphere_check.toggled.connect(_on_photon_sphere_toggled)
	photon_sphere_slider.value_changed.connect(_on_photon_sphere_changed)
	isco_check.toggled.connect(_on_isco_toggled)
	isco_slider.value_changed.connect(_on_isco_changed)
	corona_check.toggled.connect(_on_corona_toggled)
	corona_slider.value_changed.connect(_on_corona_changed)
	temperature_check.toggled.connect(_on_temperature_toggled)
	qpo_check.toggled.connect(_on_qpo_toggled)
	qpo_slider.value_changed.connect(_on_qpo_changed)
	secondary_images_check.toggled.connect(_on_secondary_images_toggled)
	frame_dragging_check.toggled.connect(_on_frame_dragging_toggled)
	spin_slider.value_changed.connect(_on_spin_changed)
	time_dilation_check.toggled.connect(_on_time_dilation_toggled)
	time_dilation_slider.value_changed.connect(_on_time_dilation_changed)
	spiral_check.toggled.connect(_on_spiral_toggled)
	spiral_count_slider.value_changed.connect(_on_spiral_count_changed)
	spiral_strength_slider.value_changed.connect(_on_spiral_strength_changed)
	hotspots_check.toggled.connect(_on_hotspots_toggled)
	hotspots_count_slider.value_changed.connect(_on_hotspots_count_changed)
	hotspots_intensity_slider.value_changed.connect(_on_hotspots_intensity_changed)
	m87_button.pressed.connect(_on_m87_preset_clicked)
	sgra_button.pressed.connect(_on_sgra_preset_clicked)
	
	gravitational_lensing_check.button_pressed = true
	render_black_hole_check.button_pressed = true
	adisk_check.button_pressed = true
	auto_fade_lensing_check.button_pressed = true
	
	setup_textures()
	setup_background_camera()
	update_ui_language()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func setup_icon_options():
	icon_option.add_item(ui_texts[current_language]["icon_option_a"], 0)
	icon_option.add_item(ui_texts[current_language]["icon_option_b"], 1)
	icon_option.selected = 0
	icon_option.item_selected.connect(_on_icon_preview_changed)
	apply_button.pressed.connect(_on_apply_icon_clicked)
	_on_icon_preview_changed(0)

func _on_icon_preview_changed(index: int):
	var icon_paths = [
		"res://pic/A.png",
		"res://pic/B.png"
	]
	
	if index >= 0 and index < icon_paths.size():
		var icon_path = icon_paths[index]
		if ResourceLoader.exists(icon_path):
			var icon_texture = load(icon_path)
			icon_display.texture = icon_texture

func _on_apply_icon_clicked():
	var index = icon_option.selected
	var icon_paths = [
		"res://pic/A.png",
		"res://pic/B.png"
	]
	
	if index >= 0 and index < icon_paths.size():
		var icon_path = icon_paths[index]
		update_project_icon(icon_path)

func update_project_icon(icon_path: String):
	var project_file = "res://project.godot"
	var absolute_path = ProjectSettings.globalize_path(project_file)
	
	var file = FileAccess.open(absolute_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var regex = RegEx.new()
		regex.compile('config/icon="[^"]*"')
		content = regex.sub(content, 'config/icon="' + icon_path + '"', true)
		
		file = FileAccess.open(absolute_path, FileAccess.WRITE)
		if file:
			file.store_string(content)
			file.close()
			
			ProjectSettings.set_setting("application/config/icon", icon_path)
			ProjectSettings.save()
			
			get_tree().create_timer(0.5).timeout.connect(_restart_application)

func _restart_application():
	get_tree().quit()
	OS.create_process(OS.get_executable_path(), [])

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
	
	if camera and shader_material:
		var distance_to_blackhole = camera.global_transform.origin.distance_to(blackhole_position)
		if distance_to_blackhole > MAX_RENDER_DISTANCE:
			shader_material.set_shader_parameter("render_black_hole", 0.0)
		elif user_render_black_hole_enabled:
			shader_material.set_shader_parameter("render_black_hole", 1.0)
	
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
		elif event.keycode == KEY_1:
			icon_panel.visible = !icon_panel.visible
			if icon_panel.visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_captured = false
		elif event.keycode == KEY_2:
			scroll_container.visible = !scroll_container.visible
			if scroll_container.visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				mouse_captured = false
		elif event.keycode == KEY_TAB:
			toggle_language()
	
	if event is InputEventMouseMotion and mouse_captured:
		camera_rotation.y -= event.relative.x * mouse_sensitivity
		camera_rotation.x -= event.relative.y * mouse_sensitivity
		camera_rotation.x = clamp(camera_rotation.x, -PI/2, PI/2)
		camera.rotation = Vector3(camera_rotation.x, camera_rotation.y, 0)

func _on_gravitational_lensing_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("gravitational_lensing", 1.0 if pressed else 0.0)

func _on_render_black_hole_toggled(pressed):
	user_render_black_hole_enabled = pressed
	if shader_material:
		var distance_to_blackhole = camera.global_transform.origin.distance_to(blackhole_position)
		if pressed and distance_to_blackhole <= MAX_RENDER_DISTANCE:
			shader_material.set_shader_parameter("render_black_hole", 1.0)
		else:
			shader_material.set_shader_parameter("render_black_hole", 0.0)

func _on_adisk_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("adisk_enabled", 1.0 if pressed else 0.0)

func _on_auto_fade_lensing_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("auto_fade_lensing", 1.0 if pressed else 0.0)

func _on_gravity_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("gravity_strength", value)
		gravity_label.text = "%s: %.2f" % [get_label_text("Gravity Strength", "引力强度"), value]

func _on_adisk_height_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_height", value)
		adisk_height_label.text = "%s: %.3f" % [get_label_text("Disk Height", "吸积盘高度"), value]

func _on_adisk_lit_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_lit", value)
		adisk_lit_label.text = "%s: %.5f" % [get_label_text("Disk Brightness", "吸积盘亮度"), value]

func _on_adisk_inner_radius_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_inner_radius", value)
		adisk_inner_radius_label.text = "%s: %.2f" % [get_label_text("Disk Inner Radius", "吸积盘内半径"), value]

func _on_adisk_outer_radius_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("adisk_outer_radius", value)
		adisk_outer_radius_label.text = "%s: %.2f" % [get_label_text("Disk Outer Radius", "吸积盘外半径"), value]
		adisk_outer_radius_value = value

func _on_cube_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("cube_enabled", 1.0 if pressed else 0.0)

func _on_cube_emission_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("cube_emission_strength", value)
		cube_emission_label.text = "%s: %.2f" % [get_label_text("Cube Emission", "立方体发光强度"), value]

func _on_doppler_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("doppler_enabled", 1.0 if pressed else 0.0)

func _on_doppler_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("doppler_strength", value)
		doppler_label.text = "%s: %.2f" % [get_label_text("Doppler Strength", "多普勒强度"), value]

func _on_beaming_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("beaming_enabled", 1.0 if pressed else 0.0)

func _on_beaming_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("beaming_strength", value)
		beaming_label.text = "%s: %.1f" % [get_label_text("Beaming Strength", "束射强度"), value]

func _on_jet_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("jet_enabled", 1.0 if pressed else 0.0)

func _on_jet_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("jet_intensity", value)
		jet_label.text = "%s: %.1f" % [get_label_text("Jet Intensity", "喷流强度"), value]

func _on_jet_rotation_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("jet_rotation_speed", value)
		jet_rotation_label.text = "%s: %.1f" % [get_label_text("Jet Rotation", "喷流旋转"), value]

func _on_jet_burst_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("jet_burst_frequency", value)
		jet_burst_label.text = "%s: %.1f" % [get_label_text("Jet Burst", "喷流爆发"), value]

func _on_hawking_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("hawking_enabled", 1.0 if pressed else 0.0)

func _on_hawking_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("hawking_intensity", value)
		hawking_label.text = "%s: %.1f" % [get_label_text("Radiation Intensity", "辐射强度"), value]

func _on_grav_redshift_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("gravitational_redshift_enabled", 1.0 if pressed else 0.0)

func _on_grav_redshift_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("gravitational_redshift_strength", value)
		grav_redshift_label.text = "%s: %.1f" % [get_label_text("Redshift Strength", "红移强度"), value]

func _on_photon_sphere_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("photon_sphere_enabled", 1.0 if pressed else 0.0)

func _on_photon_sphere_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("photon_sphere_intensity", value)
		photon_sphere_label.text = "%s: %.1f" % [get_label_text("Photon Intensity", "光子球强度"), value]

func _on_isco_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("isco_enabled", 1.0 if pressed else 0.0)

func _on_isco_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("isco_intensity", value)
		isco_label.text = "%s: %.1f" % [get_label_text("ISCO Intensity", "ISCO强度"), value]

func _on_corona_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("corona_enabled", 1.0 if pressed else 0.0)

func _on_corona_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("corona_intensity", value)
		corona_label.text = "%s: %.1f" % [get_label_text("Corona Intensity", "冕强度"), value]

func _on_temperature_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("temperature_gradient_enabled", 1.0 if pressed else 0.0)

func _on_qpo_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("qpo_enabled", 1.0 if pressed else 0.0)

func _on_qpo_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("qpo_frequency", value)
		qpo_label.text = "%s: %.1f Hz" % [get_label_text("QPO Frequency", "QPO频率"), value]

func _on_secondary_images_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("secondary_images_enabled", 1.0 if pressed else 0.0)

func _on_frame_dragging_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("frame_dragging_enabled", 1.0 if pressed else 0.0)

func _on_spin_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("black_hole_spin", value)
		spin_label.text = "%s: %.2f" % [get_label_text("Black Hole Spin", "黑洞自旋"), value]

func _on_time_dilation_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("time_dilation_enabled", 1.0 if pressed else 0.0)

func _on_time_dilation_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("time_dilation_strength", value)
		time_dilation_label.text = "%s: %.1f" % [get_label_text("Dilation Strength", "膨胀强度"), value]

func _on_spiral_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("spiral_arms_enabled", 1.0 if pressed else 0.0)

func _on_spiral_count_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("spiral_arms_count", value)
		spiral_count_label.text = "%s: %d" % [get_label_text("Spiral Count", "螺旋臂数"), int(value)]

func _on_spiral_strength_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("spiral_strength", value)
		spiral_strength_label.text = "%s: %.1f" % [get_label_text("Spiral Strength", "螺旋强度"), value]

func _on_hotspots_toggled(pressed):
	if shader_material:
		shader_material.set_shader_parameter("hot_spots_enabled", 1.0 if pressed else 0.0)

func _on_hotspots_count_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("hot_spots_count", value)
		hotspots_count_label.text = "%s: %d" % [get_label_text("Hot Spots Count", "热点数量"), int(value)]

func _on_hotspots_intensity_changed(value):
	if shader_material:
		shader_material.set_shader_parameter("hot_spots_intensity", value)
		hotspots_intensity_label.text = "%s: %.1f" % [get_label_text("Hot Spots Intensity", "热点强度"), value]

func _on_m87_preset_clicked():
	spin_slider.value = 0.9
	_on_spin_changed(0.9)
	
	jet_slider.value = 3.5
	_on_jet_changed(3.5)
	
	jet_check.button_pressed = true
	_on_jet_toggled(true)
	
	frame_dragging_check.button_pressed = true
	_on_frame_dragging_toggled(true)
	
	beaming_check.button_pressed = true
	_on_beaming_toggled(true)
	
	beaming_slider.value = 3.0
	_on_beaming_changed(3.0)
	
	doppler_check.button_pressed = true
	_on_doppler_toggled(true)
	
	doppler_slider.value = 1.0
	_on_doppler_changed(1.0)
	
	grav_redshift_check.button_pressed = true
	_on_grav_redshift_toggled(true)
	
	temperature_check.button_pressed = true
	_on_temperature_toggled(true)
	
	hotspots_check.button_pressed = false
	_on_hotspots_toggled(false)
	
	qpo_check.button_pressed = false
	_on_qpo_toggled(false)

func _on_sgra_preset_clicked():
	spin_slider.value = 0.7
	_on_spin_changed(0.7)
	
	jet_slider.value = 2.0
	_on_jet_changed(2.0)
	
	jet_check.button_pressed = false
	_on_jet_toggled(false)
	
	frame_dragging_check.button_pressed = true
	_on_frame_dragging_toggled(true)
	
	beaming_check.button_pressed = true
	_on_beaming_toggled(true)
	
	hotspots_check.button_pressed = true
	_on_hotspots_toggled(true)
	
	hotspots_count_slider.value = 4.0
	_on_hotspots_count_changed(4.0)
	
	qpo_check.button_pressed = true
	_on_qpo_toggled(true)
	
	qpo_slider.value = 4.5
	_on_qpo_changed(4.5)
	
	adisk_height_slider.value = 0.7
	_on_adisk_height_changed(0.7)

func get_label_text(en_text: String, zh_text: String) -> String:
	return en_text if current_language == "en" else zh_text

func toggle_language():
	current_language = "zh" if current_language == "en" else "en"
	update_ui_language()

func update_ui_language():
	var texts = ui_texts[current_language]
	
	$UI/IconPanel/VBox/IconLabel.text = texts["icon_title"]
	apply_button.text = texts["apply_button"]
	
	var selected_idx = icon_option.selected
	icon_option.clear()
	icon_option.add_item(texts["icon_option_a"], 0)
	icon_option.add_item(texts["icon_option_b"], 1)
	icon_option.selected = selected_idx
	
	$UI/ScrollContainer/VBoxContainer/Label.text = texts["blackhole_title"]
	gravitational_lensing_check.text = texts["gravitational_lensing"]
	render_black_hole_check.text = texts["render_blackhole"]
	adisk_check.text = texts["accretion_disk"]
	auto_fade_lensing_check.text = texts["auto_fade"]
	cube_check.text = texts["emissive_cube"]
	doppler_check.text = texts["doppler_effect"]
	beaming_check.text = texts["relativistic_beaming"]
	jet_check.text = texts["black_hole_jets"]
	hawking_check.text = texts["hawking_radiation"]
	grav_redshift_check.text = texts["gravitational_redshift"]
	photon_sphere_check.text = texts["photon_sphere"]
	isco_check.text = texts["isco_ring"]
	corona_check.text = texts["xray_corona"]
	temperature_check.text = texts["temperature_gradient"]
	qpo_check.text = texts["qpo"]
	secondary_images_check.text = texts["secondary_images"]
	frame_dragging_check.text = texts["frame_dragging"]
	time_dilation_check.text = texts["time_dilation"]
	spiral_check.text = texts["spiral_arms"]
	hotspots_check.text = texts["hot_spots"]
	$UI/ScrollContainer/VBoxContainer/PresetLabel.text = texts["preset_title"]
	m87_button.text = texts["m87_button"]
	sgra_button.text = texts["sgra_button"]
	
	_on_gravity_changed(gravity_slider.value)
	_on_adisk_height_changed(adisk_height_slider.value)
	_on_adisk_lit_changed(adisk_lit_slider.value)
	_on_adisk_inner_radius_changed(adisk_inner_radius_slider.value)
	_on_adisk_outer_radius_changed(adisk_outer_radius_slider.value)
	_on_cube_emission_changed(cube_emission_slider.value)
	_on_doppler_changed(doppler_slider.value)
	_on_beaming_changed(beaming_slider.value)
	_on_jet_changed(jet_slider.value)
	_on_jet_rotation_changed(jet_rotation_slider.value)
	_on_jet_burst_changed(jet_burst_slider.value)
	_on_hawking_changed(hawking_slider.value)
	_on_grav_redshift_changed(grav_redshift_slider.value)
	_on_photon_sphere_changed(photon_sphere_slider.value)
	_on_isco_changed(isco_slider.value)
	_on_corona_changed(corona_slider.value)
	_on_qpo_changed(qpo_slider.value)
	_on_spin_changed(spin_slider.value)
	_on_time_dilation_changed(time_dilation_slider.value)
	_on_spiral_count_changed(spiral_count_slider.value)
	_on_spiral_strength_changed(spiral_strength_slider.value)
	_on_hotspots_count_changed(hotspots_count_slider.value)
	_on_hotspots_intensity_changed(hotspots_intensity_slider.value)
