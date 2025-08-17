class_name DaggerObject
extends Node2D

@export_category("Nodes")
@export var anim: AnimationPlayer
@export var audio: AudioStreamPlayer2D
@export var noeffect_label: Label

@export_category("Properties")
@export var is_effect: bool = false

func _ready():
	if is_effect:
		noeffect_label.text = "Killed!"
func cut_effect() -> void:
	if !is_effect:
		noeffect_label.visible = true
	anim.play("Cut", -1, 1.5)
	audio.play()
	if !is_effect:
		await anim.animation_finished
		noeffect_label.visible = false
