class_name MainMenu
extends Control

@export_category("Menu Info")
@export var bg: Parallax


func _ready():
	# set in case of missing reference
	if (bg == null):
		bg = get_node("ParallaxComponent")
		
func change_scene_to(scene: String):
	get_tree().change_scene_to_file(scene)
	


func _on_tutorial_pressed():
	change_scene_to("res://Scenes/Tutorial.tscn")
