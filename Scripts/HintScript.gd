class_name HintComponent
extends Handler

@export_category("Hint Nodes")
@export var text_node: Label
@export var audio: AudioStreamPlayer2D

var hint_text: String
var hint_speed: float

const DEFAULT_STRING: String = "How can I figure out this problem?

The Simplest way to understand this problem is to know how this problem works.

One of the ways that I find it most helpful is to learn the problem



1/2"

const DEFAULT_SPEED = 2.0

func _init(hint: String = DEFAULT_STRING, speed: float = DEFAULT_SPEED):
	hint_text = hint
	hint_speed = speed

func _ready():
	get_tree().paused = true
	text_node.text = hint_text
	audio.play()
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(text_node, "visible_characters", len(hint_text), hint_speed)
	await tween.finished
	audio.stop()



func _on_exit_hint_pressed():
	audio.stop()
	get_tree().paused = false
	queue_free()
