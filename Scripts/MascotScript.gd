class_name MascotComponent
extends AnimatedCharacterInterface

signal speech_finished

@export_category("Mascot Properties")
@export var sprite: AnimatedSprite2D
@export var animator: AnimationPlayer
@export var dialogues: Array[DialogueComponent]
@export var main: Handler # world map or node



func _ready():
	if main == null && get_parent() != null:
		main = get_parent() # must be a node2D and have a handler script for dialogue
	
	self.connect("speech_finished", Callable(main, 'increment_stage'))
	self.connect("speech_finished", Callable(self, 'get_bank'))
	get_bank() # get the dialogues to start

## very simple, gets the latest dialogue in the bank, then speaks
func get_bank() -> void:
	self.dialogues = main.dialogue_bank(self)
	
	# to prevent erroring, only speak if there is words to be said
	if len(self.dialogues) > 0: 
		speak("", 0)

# Dialogue Functions

## Handles creating and initializing character speech bubbles, with speech_bank_idx
	## as a fallback in case the dialogue is from the speech bank
func speak(dialogue: String = "", speech_bank_idx: int = -1) -> void:
	# prevent errors from finishing dialogue
	if speech_bank_idx < len(dialogues):
		var sp_comp: DialogueComponent = self.dialogues[speech_bank_idx]
		
		if dialogue == "" || dialogue == null:
			dialogue = sp_comp.get_text()
		
		react_to(Event.SPEAKING)
		mood(sp_comp.mood)
		
		self.add_child.call_deferred(sp_comp) # auto text
		
		# hard-coded but this properly centers all text boxes
		sp_comp.position.y -= 64
		sp_comp.position.x -= 64
		
		await sp_comp.text_finished
	
	if (speech_bank_idx + 1 < len(dialogues)):
		speak("", speech_bank_idx + 1)
	else:
		speech_finished.emit()



func react_to(event: Event) -> void:
	match event:
		Event.SPEAKING:
			animator.play("Talking", -1, 2.0)

## AnimatedSprite2D is the "mood" of the character
func mood(char_mood: String) -> void:
	sprite.play(char_mood)
		
	
func cancel_behavior() -> void:
	push_error("cancel_behavior() must be implemented by subclass.")
	pass
