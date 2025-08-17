class_name PizzaHandler
extends Handler


@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[TheoryResource] # store level data 

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
	
	if Global.curr_level_idx == 2:
		$LazyCatererEq.visible = true
		$Bernoulli.visible = true
