class_name JosephusComponent
extends Node2D

@export_category("Josephus Properties")
@export var number_chairs: int = 16
@export var number_contestants: int = 4
@export var distance_from_center: float = 32.0 
@export var colors: Array[Color] = []

@export_category("Josephus Nodes")
@export var dagger_ref: Node2D
@export var current_chair: int = 0
@export var audio: AudioStreamPlayer2D

@export_category("Loads")
@export var chair_texture: Texture
@export var contestant_texture: Texture
@export var dagger_texture: Texture

@export var dagger_move_audio: AudioStream
@export var dagger_cut_audio: AudioStream

func _ready():
	initialize_chairs()
	initialize_dagger()
	
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
	if event is InputEventKey and (event as InputEventKey) and event.is_released():
		var angle: float = 360/number_chairs
		if event.is_action_released("ui_left"):
			current_chair -= 1
		elif event.is_action_released("ui_right"):
			current_chair += 1
		
		current_chair = normalize_chair_num(current_chair)
		dagger_ref.position = position_at_angle(360/number_chairs * current_chair) * 5/6
		
		if (audio.stream != dagger_move_audio):
			audio.stream = dagger_move_audio
		audio.play()

	
## Function exists so that cycles go from 0 to number_chairs - 1 for indexing
func normalize_chair_num(num: int) -> int:
	if current_chair < 0:
		return number_chairs - 1
	elif current_chair >= number_chairs:
		return 0
	else:
		return num

func initialize_dagger() -> void:
	var dagger: Node2D = Node2D.new()
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = dagger_texture
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	dagger.add_child(sprite)
	add_child(dagger)
	dagger_ref = dagger # set the ref for later
	dagger.scale = Vector2(2,2) # scale it up a lil bit
	dagger.position = position_at_angle(0) * 5/6

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
		
		# add color while there exists remaining colors
		if len(colors) > 0:
			contestant.modulate = colors[0]
			colors.remove_at(0)
		
		contestant.visible = false # hide them (though they technically exist)
		if i < number_contestants:
			contestant.visible = true
			

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
