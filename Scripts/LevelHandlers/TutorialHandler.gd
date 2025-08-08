class_name TutorialHandler
extends Handler

signal stage_changed

var dialogue_scene = preload("res://Components/DialogueComponent.tscn")

func increment_stage() -> void:
	super.increment_stage()

func _ready():
	$TutorialSong.playing = true
	
func dialogue_bank(node: AnimatedCharacterInterface) -> Array[DialogueComponent]:
	var bank: Array[DialogueComponent] = []
	
	var text_arr: Array = []
	match speech_stage:
		0:
			if (node is MascotComponent):
				text_arr = [ 
					["Hello, welcome to the tutorial!", 1.0, "Wave"],
					[" In this tutorial I will show you", 1.5, "Speaking"], 
					["How to interact with my teaching tool!", 1.4, "Speaking"]
					]
		1: 
			if (node is MascotComponent):
				
				node.move_to(node, Vector2(-91, 84), 1.0)
				
				text_arr = [
					["Over here is the game buttons", 0.6, "Question"],
					["This first one is for accessing settings, like volume!", 0.8, "Speaking"],
					["The one on the right is for hints, to get help!", 0.5, "Thinking"],
					["The BIG middle one is to answer the question!", 0.6, "Correct"],
					["The bar chart shows your stats if you are curious", 0.7, "Speaking"],
					["And the last one is if you ever want to restart the level!", 0.6, "Time"]
				]
		2: 
			if (node is MascotComponent):
				node.move_to(node, Vector2(122, -80), 1.0)
				
				text_arr = [
					["Up here are the timer and the hint counter", 0.7, "Thinking"],
					["When you get an answer incorrect, you lose a hint, but...", 0.9, "Incorrect"],
					["... Keep going! There is no penalty aside from losing hints.", 0.8, "Correct"],
					["The timer will be used to calculate your final score!", 0.9, "Time"],
				]
		3: 
			if (node is MascotComponent):
				node.move_to(node, Vector2.ZERO, 1.0)
				
				text_arr = [
					["That's all for the tutorial! Exit to the menu and choose a topic!", 1.0, "Wave"]
				]
	
	# add all speech dialogues to bank
	for i in text_arr:
		var component: DialogueComponent = dialogue_scene.instantiate() as DialogueComponent
		component.setup(i[0], i[1], i[2])
		bank.append(component)
	
	return bank


func _on_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
