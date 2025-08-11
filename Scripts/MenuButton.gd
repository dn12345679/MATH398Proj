extends Node2D


func _on_return_pressed():
	Global.curr_level_idx = 0
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
