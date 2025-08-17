class_name JosephusComponent
extends Node2D

@export_category("Josephus Properties")
@export var number_chairs: int = 16
@export var number_contestants: int = 16
@export var distance_from_center: float = 32.0 
@export var colors: Array[Color] = []
@export var simulation_speed_multiplier: float = 1.0


var is_simulating: bool = false
var can_simulate: bool = false # knife will change effect else


@export_category("Josephus Nodes")
@export var dagger_ref: Node2D
@export var current_chair: int = 0
@export var audio: AudioStreamPlayer2D

@export var contestants: Array[Sprite2D]

@export_category("Loads")
@export var chair_texture: Texture
@export var contestant_texture: Texture
@export var dagger_texture: Texture

@export var dagger_move_audio: AudioStream
@export var dagger_cut_audio: AudioStream

func _ready():
	initialize_chairs()
	dagger_ref.position = position_at_angle(0) * 5/6

	
## NOTE: Function is called in parent Handler
func _randomize_seating() -> void:
	var number_left: int = number_contestants
	var participants: Array = range(number_chairs)

	participants.shuffle()
	for i in range(len(participants)):
		var chair: Node2D = get_node(str(participants[i]))
		
		## Code rlies  on the fact that the 2nd child is the participant
		var participant: Node2D = chair.get_child(1)
		participant.visible = false
		if number_left > 0:
			participant.visible = true
			number_left -= 1
			if i < len(colors):
				print(colors[i])
				participant.modulate = colors[i]
		

		

func _input(event):
	if is_simulating: return # don't allow any input while simulating
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_RIGHT || event.keycode == KEY_LEFT:

			if event.is_action_released("ui_left"):
				current_chair -= 1
			elif event.is_action_released("ui_right"):
				current_chair += 1
			
			shift_chair()

		if event.keycode == KEY_SPACE:
			dagger_ref.cut_effect()

	
## Function exists so that cycles go from 0 to number_chairs - 1 for indexing
func normalize_chair_num(num: int) -> int:
	if current_chair < 0:
		return number_chairs - 1
	elif current_chair >= number_chairs:
		return 0
	else:
		return num


func get_current_angle(pos: Vector2) -> float:
	return rad_to_deg(get_angle_to(pos))

## Given any input angle 'theta', return the corresponding vector position
func position_at_angle(theta: float) -> Vector2:
	return Vector2(cos(deg_to_rad(theta)), sin(deg_to_rad(theta))) * distance_from_center * sqrt(number_chairs)

## initializes participants and chairs based on properties
func initialize_chairs() -> void:
	for i in range(number_chairs):
		
		var chair: Node2D = create_chair(i) 
		add_child(chair)
		var angle_deg: float = 360/number_chairs * i
		chair.position = position_at_angle(angle_deg)
		
		# only add contestants if there is a number
		var contestant: Sprite2D = Sprite2D.new()
		contestant.texture = contestant_texture
		contestant.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		chair.add_child(contestant)
		contestant.position.y -= distance_from_center / sqrt(number_chairs)
		
		contestant.name = str(i)
		
		# add color while there exists remaining colors
		if len(colors) > 0:
			contestant.modulate = colors[0]
			colors.remove_at(0)
		
		contestant.visible = false # hide them (though they technically exist)
		if i < number_contestants:
			contestant.visible = true
		contestants.append(contestant) # for iteration
		
			

## Creates a chair object for nodes to sit on
func create_chair(id: int) -> Node2D:
	var chair: Node2D = Node2D.new()
	var chair_img: Sprite2D = Sprite2D.new()
	chair_img.texture = chair_texture
	chair.add_child(chair_img)
	chair_img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	chair.name = str(id)
	chair.add_to_group("JosephusChair")
	
	return chair

## handle simulating
## Given a starting index current_chair, the number of remaining people n, and the 
## number of deaths per hand k, runs 1 simulation of Josephus
func _on_button_pressed( n: int = number_chairs, k: int = 2) -> void:
	if !is_simulating:
		is_simulating = true # to prevent spamming
		dagger_ref.is_effect = is_simulating
		run_josephus(current_chair, n, k)
		
		

func run_josephus(i: int, n: int, k: int) -> void:
	var alive: Array[bool] = []
	for contestant in range(n):

		alive.append(contestants[contestant].visible)
	
	current_chair = i # starting
	var count: int = 0
	
	while alive.count(true) > 1:
		if alive[current_chair]:
			count += 1
			if count == k:
				dagger_ref.cut_effect()
				contestants[current_chair].modulate.a = 0.3 # change visual
				alive[current_chair] = false # set them as dead
				count = 0 # reset
			
		# set as -1 if you want to go a different direction
		current_chair = (current_chair + 1) % n # back to start if idx = n
		
		await get_tree().create_timer(0.5 * (1/simulation_speed_multiplier)).timeout
		shift_chair()	
	
	is_simulating = false
	dagger_ref.is_effect = is_simulating

func shift_chair() -> void:
	var angle: float = 360/number_chairs
	
	current_chair = normalize_chair_num(current_chair)
	dagger_ref.position = position_at_angle(360/number_chairs * current_chair) * 5/6
	
	if (audio.stream != dagger_move_audio):
		audio.stream = dagger_move_audio
	audio.play()		
