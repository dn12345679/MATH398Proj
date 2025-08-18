class_name SquareHandler
extends Handler

@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[TheoryResource] # store level data 
@export var add_new_button: TextureButton
@export var center_box: TheoryBox

@export var custom_lengths: MenuButton
@export var popup: Popup

@export var squares: Array[TheorySquare] = []
@export var max_squares: int = 1


@export_category("Loads")
@onready var cube: PackedScene = preload("res://Components/TheorySquare.tscn")

func _ready():
	super._ready()
	audio.play()
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		super.handle_all_levels_complete()	

## handles card drawing, setting scene, etc
func handle_level(res: TheoryResource):
	
	obj.text = res.objective_type
	objective.update_text(res.description) # handler main class
	max_squares = res.max_cubes
	center_box.extents_length = res.box_dimension
	center_box.initialize_box(center_box.extents_length)
	
	popup = custom_lengths.get_popup()
	popup.id_pressed.connect(_on_popup_pressed)
	
	custom_lengths.visible = res.dropdown_visible

func _on_get_new_button_down():
	if len(squares) < max_squares:
		var p: TheorySquare = cube.instantiate() as TheorySquare
		add_child(p)
		p.set_drag_state(true)
		p.global_position = add_new_button.global_position
		squares.append(p)
		

func _on_kill_box_body_entered(body):
	squares.remove_at(squares.find(body))
	body.queue_free()
	
func _on_popup_pressed(id: int): 
	center_box.extents_length = float(popup.get_item_text(id))
	center_box.initialize_box(center_box.extents_length)
	for children in squares:
		squares.remove_at(squares.find(children))
		children.queue_free()
	custom_lengths.text = str("Length: " + str(center_box.extents_length))

