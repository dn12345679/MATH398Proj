class_name Handler
extends Node

@export var speech_stage = 0 # all speech imported by stage

func increment_stage() -> void:
	speech_stage += 1
	emit_signal("stage_changed") 
func decrement_stage() -> void:
	speech_stage -= 1
	emit_signal("stage_changed")

## TODO: Implement inside the class
func dialogue_bank(_node: AnimatedCharacterInterface) -> Array[DialogueComponent]:
	return []
