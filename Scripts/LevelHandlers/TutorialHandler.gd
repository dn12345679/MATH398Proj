class_name TutorialHandler
extends Handler



func increment_stage() -> void:
	super.increment_stage()

func _ready():
	$TutorialSong.playing = true

func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
