class_name ObjectiveComponent
extends Node2D

@export_category("Nodes")
@export var main: Handler
@export var anim: AnimationPlayer
@export var audio: AudioStreamPlayer2D
@export var text_node: Label

@export var text: String

func _input(event):
	if event is InputEventMouseButton and visible == true:
		anim.play("Exit")
		await anim.animation_finished
		get_tree().paused = false
		visible = false

func _ready():
	intro()
	
func intro() -> void:
	get_tree().paused = true
	anim.play("Intro", -1, 1.5)
	audio.play()	

func update_text(new_text: String) -> void:
	text = new_text
	text_node.text = new_text

func is_complete() -> bool:
	return false
	


