class_name TheoryCoin
extends Control

signal increment(denom)
signal decrement(denom)

@export_category("Coin Properties")
@export var denomination: int = 1

@export_category("Nodes")
@export var anim: AnimatedSprite2D
@export var label: Label
@export var main_parent: Handler

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("CoinSpin")

	$ClickNode.connect(
		"gui_input", Callable(self, "_on_coin_clicked").bind(denomination)
	)

func _on_coin_clicked(event, value):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			increment.emit(value)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			decrement.emit(value)
		

func set_denomination(new_denomination: int) -> void:
	label.text = str(new_denomination)
	denomination = new_denomination
	anim.play("CoinSpin")


