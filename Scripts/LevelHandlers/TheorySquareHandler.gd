class_name SquareHandler
extends Handler

@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[TheoryResource] # store level data 
@export var add_new_button: TextureButton

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



func _on_get_new_button_down():
	var p: TheorySquare = cube.instantiate() as TheorySquare
	add_child(p)
	p.set_drag_state(true)
	p.global_position = add_new_button.global_position


func _on_kill_box_body_entered(body):
	
	body.queue_free()
	
