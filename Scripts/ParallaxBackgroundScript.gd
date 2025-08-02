class_name Parallax
extends Node2D


var hr: int = 12 # default midday
@export var bg_use: int = -1 # set of backgrounds
@export var scale_bg: float = 1
@export var alpha_scale: float = 1.0
var speed_scale: float = 0.3

const MAX_LAYERS: int = 6 # depends on number of images in folder
const FOLDER_PATH: String = "res://Assets/Clouds/"

# private thing; only so I can easily switch around the backgrounds in 1 line
var bg_vals: Array[int] = [6, 2, 5, 1, 4, 7, 3, 8]

@export var c_layer: CanvasLayer
@export var p_bg: ParallaxBackground
@export var main_world_cam: Camera2D

# shader
@onready var pixelate: ShaderMaterial

var is_ready: bool = false # is it ready to parallax?
@export var scroll_offset: Vector2 = Vector2.ZERO
@export var scroll_speed: float = 40.0

func _ready():
	# default unless otherwise specified
	if main_world_cam == null:
		# main_world_cam = get_tree().root.get_node("CameraComponent")
		pass
		
	# set by hour by default
	if bg_use == -1:
		hr = Time.get_datetime_dict_from_system()["hour"]
		get_daylight_classification(hr) # set bg_use
	
	# if custom, load the custom export
	load_images(bg_use)
	

	
	# attempt to find the default
	# c_layer.offset.x = main_world_cam.get_screen_center_position().x - global_position.x
	is_ready = true # start parallaxing

# in case I need to print the English classification
func get_daylight_classification(hour: int) -> String:
	if hour > 4 and hour <= 8:
		bg_use = bg_vals[0]
		return "Early Morning"
	elif hour > 8 and hour <= 12:
		bg_use = bg_vals[1]
		return "Late Morning"
	elif hour > 12 and hour <= 15:
		bg_use = bg_vals[2]
		return "Early Afternoon"
	elif hour > 15 and hour <= 17:
		bg_use = bg_vals[3]
		return "Late Afternoon"
	elif hour > 17 and hour <= 19:
		bg_use = bg_vals[4]
		return "Early Evening"
	elif hour > 19 and hour < 21:
		bg_use = bg_vals[5]
		return "Early Night"
	elif hour >= 21:
		bg_use = bg_vals[6]
		return "Night"
	elif hour >= 0 and hour <= 4:
		bg_use = bg_vals[7]
		return "Late Night"
	
	return "Early Afternoon"

# laods the parallaxing backgrounds for all scenes. 
# bg_val is an integer representing the classification above
# you can load different backgrounds that aren't just the time of the day
func load_images(bg_val: int) -> void:
	for bg in range(1, 7):
		var path: String = FOLDER_PATH + "Clouds " + str(bg_val) + "/" + str(bg) + ".png"
		if ResourceLoader.exists(path):
			var p_layer: ParallaxLayer = ParallaxLayer.new()
			var p_sprite: Sprite2D = Sprite2D.new()
			
			p_sprite.texture = load(path) # load bg
			p_sprite.scale = Vector2(scale_bg, scale_bg)
			p_sprite.modulate.a = alpha_scale
			
			p_layer.motion_mirroring = Vector2(p_sprite.texture.get_width() * scale_bg , p_sprite.texture.get_height() * scale_bg)
			p_layer.motion_scale = Vector2(speed_scale, speed_scale)
			
			# randomize speeds of background components
			
			if bg % 2 == 0:
				speed_scale = 0.1
			else:
				speed_scale = 0.3
			
			# only add parallaxing if its not the background
			if bg != 1:
				p_layer.add_child(p_sprite)
				p_bg.add_child(p_layer)		
				
				pixelate = ShaderMaterial.new()
				pixelate.shader = preload("res://Scripts/pixelation.gdshader")
				p_sprite.material = pixelate
				
			else:
				# plain background color
				p_sprite.scale = Vector2(20, 20)
				p_bg.add_child(p_sprite)

			var tween: Tween = create_tween()
			tween.tween_method(
				set_pixelation,
				4.0,
				1.0,
				0.4
			)

func set_pixelation(val: float) -> void:
	pixelate.set_shader_parameter("pixelation_amount", val)
				
func _process(delta):		
	if is_ready:
		p_bg.scroll_offset = scroll_offset
		scroll_offset.x -= scroll_speed * delta
