class_name Handler
extends Node

@export var speech_stage = 0 # all speech imported by stage

@export_category("Components")
@export var objective: ObjectiveComponent
@export var game_ui: UIComponent
@export var mascot: MascotComponent
@export var camera: DynamicCamera


func _ready():
	if !objective || !game_ui || !mascot || !camera :
		print("Missing game component")
	

func increment_stage() -> void:
	speech_stage += 1
	emit_signal("stage_changed") 
func decrement_stage() -> void:
	speech_stage -= 1
	emit_signal("stage_changed")

## TODO: Implement inside the class
func dialogue_bank(_node: AnimatedCharacterInterface) -> Array[DialogueComponent]:
	return []
