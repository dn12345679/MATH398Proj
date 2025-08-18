class_name TheoryCoin
extends Control

signal increment(denom)
signal decrement(denom)

@export_category("Coin Properties")
@export var denomination: int = 1

@export_category("Nodes")
@export var anim: AnimatedSprite2D
@export var animator_effect: AnimationPlayer
@export var label: Label
@export var main_parent: Handler
@export var audio: AudioStreamPlayer2D

@export var coin_up: AudioStream 
@export var coin_down: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("CoinSpin")

	
	$ClickNode.connect(
		"gui_input", Callable(self, "_on_coin_clicked").bind(denomination)
	)

func _on_coin_clicked(event, value):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			audio.stream = coin_up
			increment.emit(value)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			decrement.emit(value)
			audio.stream = coin_down
		audio.play()
		animator_effect.play("Clicked", -1, 2.0)

func set_denomination(new_denomination: int) -> void:
	label.text = str(new_denomination)
	denomination = new_denomination
	anim.play("CoinSpin")


