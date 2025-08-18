class_name BuffonHandler
extends Handler

@export_category("Stats")
@export var num_placed: int = 0
@export var num_intersections: int = 0

@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[StatResource]
@export var stat_node: ColorRect

@export_category("Resource Properties")
@export var needle_length: float
@export var line_distance: float

@export_category("Line properties")
@export var line_points: Array[Vector2] = []
@export var left_line_limit_x: float = -288.0
@export var right_line_limit_x: float = 136
@export var top_line_limit_y: float = 160
@export var bottom_line_limit_y: float = -160

@export_category("Loads")
@export var needle_texture: Texture
@export var needle_drop_sfx: AudioStream
@export var needle_drop_sfx_loud: AudioStream

func _ready():
	super._ready()
	audio.play()
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		super.handle_all_levels_complete()
	
	if Global.curr_level_idx == 2:
		get_node("BuffonNeedle").visible = true

## handles card drawing, setting scene, etc
func handle_level(res: StatResource):
	obj.text = res.objective_type
	objective.update_text(res.description)
	needle_length = res.needle_length
	line_distance = res.line_distance
	initialize_buffon()
	get_node("Drop100").visible = res.can_drop_100

func initialize_buffon() -> void:
	var num_lines_half = top_line_limit_y/line_distance # if there is distance, 40, then 4 lines go top,
	var lines: Array[Vector2] = []
	# creates 2 lines, the top and its mirror on the bottom
	for i in range(num_lines_half):
		lines.append(Vector2(left_line_limit_x, i * line_distance))
		lines.append(Vector2(right_line_limit_x, i * line_distance))
		
		# add the "negative" set
		lines.append(Vector2(left_line_limit_x, -i * line_distance))
		lines.append(Vector2(right_line_limit_x, -i * line_distance))
	line_points = lines  # set new points
	queue_redraw()

func _draw():
	for i in range(0, len(line_points) - 1, 2):
		draw_line(line_points[i], line_points[i + 1], Color.WHITE, 2)
	



func _on_drop_needle_pressed():
	drop_needle()

func _on_drop_100_pressed():
	var anvil_sound: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	anvil_sound.stream = needle_drop_sfx_loud
	anvil_sound.bus = "SFX"
	anvil_sound.volume_db = -10
	add_child(anvil_sound)
	anvil_sound.play()
	
	
	for i in range(0, 100):
		drop_needle()
		await get_tree().create_timer(0.01).timeout
	anvil_sound.queue_free()
	
func drop_needle() -> void:
	var x_coord_rand: float = randf_range(left_line_limit_x + needle_length * 0.5, right_line_limit_x - needle_length * 0.5)
	var y_coord_rand: float = randf_range(bottom_line_limit_y + needle_length * 0.5, top_line_limit_y - needle_length * 0.5)
	var rotate_rand: float = randf_range(0, 360)
	
	var needle: Sprite2D = Sprite2D.new()
	var audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	audio.stream = needle_drop_sfx
	audio.bus = "SFX"
	audio.volume_db = -10
	
	needle.texture = needle_texture
	# the needle is 32x32, so I need to find the factor to scale up/down to needle,length
	var factor_y: float = needle_length/256
	needle.scale = Vector2(0.005, factor_y) * 3 # REASON FOR 3: Arbitrary constant, just want to 
												# give it some impact/effect
	add_child(needle)
	needle.add_child(audio)
	audio.play()

	needle.rotation_degrees = rotate_rand
	needle.position = Vector2(x_coord_rand, y_coord_rand)

	## NOTE: I fix by 90 since rotation is weird, but it works
	var angle_rad: float = deg_to_rad(rotate_rand + 90) # 
	var start_point = needle.position - Vector2(
		cos(angle_rad) * 0.5 * needle_length, 
		sin(angle_rad) * 0.5 * needle_length  
	)

	var end_point = needle.position + Vector2(
		cos(angle_rad) * 0.5 * needle_length,  
		sin(angle_rad) * 0.5 * needle_length   
	)

	for i in range(0, len(line_points) - 1, 2):
		# do cool things here for intersections
		if Geometry2D.segment_intersects_segment(line_points[i], line_points[i + 1], start_point, end_point):
			num_intersections += 1
			needle.modulate.a = 0.3
			break # DO NOT CONSIDER DOUBLE INTERSECTIONS AS THAT IS NOT POSSIBLE FOR BUFFON

	num_placed += 1
	stat_node.get_node("LinesCrossed").text = str("Line crossed: " + str(num_intersections))
	stat_node.get_node("TotalDrops").text = str("Total drops: " + str(num_placed))
	
	
	var tween_scale: Tween = get_tree().create_tween()
	tween_scale.tween_property(needle, "scale", needle.scale * 1/3, 0.3)
