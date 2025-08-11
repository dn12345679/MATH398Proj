class_name DaggerHandler
extends Handler

@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[StatResource]

@export var josephus_obj: JosephusComponent


func _ready():
	super._ready()
	audio.play()
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		super.handle_all_levels_complete()

## handles card drawing, setting scene, etc
func handle_level(res: StatResource):
	obj.text = res.objective_type
	objective.update_text(res.description)
	josephus_obj.number_contestants = res.number_contestants
	if res.colors != null and len(res.colors) > 0:
		josephus_obj.colors = res.colors
	
	josephus_obj._randomize_seating()
