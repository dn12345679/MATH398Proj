class_name DialogueComponent
extends Control

signal animation_finished(animation)
signal text_finished

@export_category("Dialogue Options")
@export var text: String = ""
@export var text_duration: float = 1.0
@export var mood: String = "Idle" # implemented in classes
@onready var animator: AnimationPlayer = $BubbleAnimation

@export var text_node: Label
@export var color_node: ColorRect
@export var audio: AudioStreamPlayer2D



func setup(new_text: String, duration: float, init_mood: String):
	text = new_text
	text_duration = duration
	if text_node:
		text_node.text = text
	self.mood = init_mood

func _ready():
	self.connect("animation_finished", Callable(self, "_after_finish")) 
	self.connect("text_finished", Callable(self, "remove_self"))
	play()

func play():
	animate("Bounce")
	play_text(text_duration)	

## Functions that speech bubbles must have

# SET/GET text
func set_text(string: String) -> void:
	text = string
func get_text() -> String:
	return text
func get_duration() -> float:
	return text_duration
func set_duration(duration: float) -> void:
	text_duration = duration

# play animations
func animate(anim: String) -> void:
	animator.play(anim, -1, 2.0)
	emit_signal("animation_finished", anim)
	
func play_text(duration: float) -> void:
	var tween: Tween = get_tree().create_tween()
	audio.play()
	tween.tween_property(text_node, "visible_characters", len(text), duration)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if (text_node.visible_characters < len(text)):
			text_node.visible_characters = len(text)
		elif (text_node.visible_characters >= len(text)):
			emit_signal("text_finished")

# important: only runs after animation is finished
func _after_finish(_animation) -> void:
	pass
	# other logic like changing to next text
	
func remove_self() -> void:
	animate("Exit")
	await animator.animation_finished	
	
	queue_free()

func _to_string() -> String:
	return text
