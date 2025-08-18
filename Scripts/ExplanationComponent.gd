class_name ExplanationComponent
extends Control

signal answer_closed()

@export_category("Nodes")
@export var completion_msg: Label
@export var explanation_msg: Label


func set_completion_message(message: String, time: float) -> void:
	completion_msg.text = str("Level Complete: " + str(time) + "s")
	explanation_msg.text = message
	explanation_msg.visible_characters = 0
	var tween_char: Tween = get_tree().create_tween()
	tween_char.tween_property(explanation_msg, "visible_characters", len(message), 1.0)
	


func _on_continue_button_pressed():
	close()

func close():
	get_tree().paused = false
	visible = false
	answer_closed.emit()
