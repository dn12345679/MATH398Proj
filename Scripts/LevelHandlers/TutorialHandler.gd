class_name TutorialHandler
extends Handler

@export var levels: Array[Resource]

func increment_stage() -> void:
	super.increment_stage()

func _ready():
	
	super._ready()
	
	$TutorialSong.playing = true
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		get_tree().paused = false
		await get_tree().process_frame
		Global.curr_level_idx = 0
		get_tree().reload_current_scene()

func handle_level(res: StatResource):
	return

func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
