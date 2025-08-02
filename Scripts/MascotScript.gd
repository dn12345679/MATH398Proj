class_name MascotComponent
extends AnimatedCharacterInterface

var dialogue_scene = preload("res://Components/DialogueComponent.tscn")


@export_category("Mascot Properties")
@export var animator: AnimationPlayer
@export var dialogues: Array[DialogueComponent]
@export var main: Handler # world map or node

func dialogue_bank() -> Array[DialogueComponent]:
	var bank: Array[DialogueComponent] = []
	
	var text_arr: Array = []
	match main.speech_stage:
		0:
			text_arr = [ 
				["Hello, welcome to the tutorial!", 1.0],
				[" In this tutorial I will show you", 2.0], 
				]
	
	# add all speech dialogues to bank
	for i in text_arr:
		var component: DialogueComponent = dialogue_scene.instantiate() as DialogueComponent
		component.setup(i[0], i[1])
		bank.append(component)
	
	return bank

func _ready():
	if main == null:
		main = get_parent() # must be a node2D and have a handler script for dialogue
	 
	dialogues = dialogue_bank()
	speak("", 0)

# Dialogue Functions

## Handles creating and initializing character speech bubbles, with speech_bank_idx
	## as a fallback in case the dialogue is from the speech bank
func speak(dialogue: String = "", speech_bank_idx: int = -1) -> void:
	var sp_comp: DialogueComponent = dialogues[speech_bank_idx]
	
	if dialogue == "" || dialogue == null:
		dialogue = sp_comp.get_text()
		
	add_child(sp_comp) # auto text
	await sp_comp.text_finished
	
	if (speech_bank_idx + 1 < len(dialogues)):
		speak("", speech_bank_idx + 1)
	
@warning_ignore("unused_parameter")
func react_to(event: Event) -> void:
	push_error("react_to() must be implemented by subclass.")
	pass # usually will be a call to speak()
@warning_ignore("unused_parameter")
func _on_character_finished_speaking(character: AnimatedCharacterInterface) -> void:  # signal
	push_error("_on_character_finished_speaking() must be implemented by subclass (signal).")
	pass
func cancel_behavior() -> void:
	push_error("cancel_behavior() must be implemented by subclass.")
	pass
