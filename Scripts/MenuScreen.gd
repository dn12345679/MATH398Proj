class_name MainMenu
extends Control

@export_category("Menu Info")
@export var bg: Parallax

@export var level_nodes: Control


func _ready():
	# set in case of missing reference
	if (bg == null):
		bg = get_node("ParallaxComponent")
		
func change_scene_to(scene: String):
	get_tree().change_scene_to_file(scene)
	


func _on_tutorial_pressed():
	change_scene_to("res://Scenes/Tutorial.tscn")


func _on_card_game_pressed():
	change_scene_to("res://Scenes/Statistics/StatisticsCardGame.tscn")



func _on_quincunx_game_pressed():
	change_scene_to("res://Scenes/Statistics/StatisticsQuincunx.tscn")
	



func _on_dagger_game_pressed():
	change_scene_to("res://Scenes/Statistics/StatisticsDagger.tscn")


func _on_statistics_pressed():
	$Statistics.visible = false
	level_nodes.visible = true
