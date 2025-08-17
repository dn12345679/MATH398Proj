class_name Handler
extends Node2D

signal stage_changed

@export var speech_stage = 0 # all speech imported by stage

var dialogue_scene: PackedScene = preload("res://Components/DialogueComponent.tscn") # for creating new objects

@export_category("Components")
@export var objective: ObjectiveComponent
@export var game_ui: UIComponent
@export var mascot: MascotComponent
@export var camera: DynamicCamera

@export var dialogue: DialogueResource ## Important


func handle_all_levels_complete() -> void:
	get_tree().paused = false
	await get_tree().process_frame
	Global.curr_level_idx = 0
	print("yeah")
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _ready():
	if !objective || !game_ui || !mascot || !camera || !dialogue:
		print("Missing game component")
		get_tree().quit(1)
	game_ui.level_handler = self

func increment_stage() -> void:
	speech_stage += 1
	emit_signal("stage_changed") 
func decrement_stage() -> void:
	speech_stage -= 1
	emit_signal("stage_changed")

func add_incorrect():
	var entry: DialogueEntry = DialogueEntry.new()
	entry.dialogue = "Incorrect!"
	entry.duration = 0.6
	entry.mood = "Incorrect"

	var component: DialogueComponent = dialogue_scene.instantiate() as DialogueComponent
	component.setup(entry.dialogue, entry.duration, entry.mood)
	mascot.speak("", 0, component)
	mascot.interjection.emit()

	#dialogue.custom_res.append(entry)

## Given a node that implements AnimatedCharacterInterface,
	## Returns an Array containing the necessary dialogue to be read by the node,
## Requirements. Handler node MUST have a reference to the "dialogue" node
func dialogue_bank(node: AnimatedCharacterInterface) -> Array[DialogueComponent]:
	var bank: Array[DialogueComponent] = [] # to be returned
	var text_arr: Array[DialogueEntry] = [] # only to be used here, checking dialogues
	
	# first iterate over all the available dialogues, 
		#then add the current ones to the bank
		# after that, remove its index to reduce iteration count (optimization)
	for e in range(len(dialogue.custom_res)):
		var d_e: DialogueEntry = dialogue.custom_res[e]
		if d_e.id == speech_stage and d_e.level == Global.curr_level_idx:
			node.move_to(node, d_e.location, 1.0)
			text_arr.append(d_e)

	# add all speech dialogues to bank (to be handled by speaker node)
	for i in text_arr:
		var component: DialogueComponent = dialogue_scene.instantiate() as DialogueComponent
		component.setup(i.dialogue, i.duration, i.mood) # initialize a new DialogueComponent
		bank.append(component) 
	
	return bank
