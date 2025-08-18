class_name MainMenu
extends Control

@export_category("Menu Info")
@export var bg: Parallax
@export var audio: AudioStreamPlayer2D

func _ready():
	# set in case of missing reference
	if (bg == null):
		bg = get_node("ParallaxComponent")
	audio.play()



func _on_quincunx_pressed():
	get_tree().change_scene_to_file("res://Scenes/Statistics/StatisticsQuincunx.tscn")


func _on_buffons_needle_pressed():
	get_tree().change_scene_to_file("res://Scenes/Statistics/StatisticsBuffonsNeedle.tscn")


func _on_josephus_permutation_pressed():
	get_tree().change_scene_to_file("res://Scenes/Statistics/StatisticsDagger.tscn")


func _on_frobenius_coin_pressed():
	get_tree().change_scene_to_file("res://Scenes/Theory/TheoryCoinProblem.tscn")


func _on_lazy_caterers_problem_pressed():
	get_tree().change_scene_to_file("res://Scenes/Theory/TheoryPizzaProblem.tscn")


func _on_square_packing_pressed():
	get_tree().change_scene_to_file("res://Scenes/Theory/TheorySquarePacking.tscn")


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
