@tool
class_name DialogueResource
extends Node

# https://github.com/godotengine/godot-proposals/issues/18#issuecomment-706795815

@export var custom_res: Array[Resource] : set = set_custom_res

func set_custom_res(value: Array[Resource]) -> void:
	custom_res.resize(value.size())
	custom_res = value
	for i in range(custom_res.size()):
		if not custom_res[i]:
			custom_res[i] = DialogueEntry.new()
			custom_res[i].resource_name = "DefaultName"
