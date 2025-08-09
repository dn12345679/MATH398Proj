class_name AnimatedCharacterInterface
extends Node2D

# Inherited field

signal dialogue_finished(character) 

enum Event {
	CORRECT,
	INCORRECT,
	PAUSE,
	SLOW,
	TIME_LOW, 
	SPEAKING
}


# Functions that need to be implemented 
	# PlayAnimation(anim, isLoop)
	# StopAnimation(anim = "none")
	# GetAnimation()
	# OnAnimationFinished(anim)
	
	# move_to(position, speed)
	# face_direction(direction)
	# teleport_to(position)
	
	# speak(dialogue, bank_index = -1)
	# react_to(event) -> uses speak()
	# finished_speaking
	# wait(secs)
	# cancel_behavior()
	
	# show/hide
	# get_camera

# Animation Functions
func play_animation(node: AnimatedSprite2D, anim: String) -> void: # IMPLEMENTED
	node.play(anim)
func stop_animation(node: AnimatedSprite2D, _anim: String = "default") -> void: # IMPLEMENTED
	node.stop()
func get_animation(node: AnimatedSprite2D) -> String: # IMPLEMENTED
	return node.animation
	
@warning_ignore("unused_parameter")	
func on_anim_finished(anim: String) -> void:
	pass
	
# Position Functions
func move_to(node: Node2D, pos: Vector2, speed: float) -> Vector2: # IMPLEMENTED
	var old_pos: Vector2 = node.position
	var pos_tween: Tween = get_tree().create_tween()
	pos_tween.tween_property(node, "position", pos, speed) 
	return old_pos # should be original position in case
	
	
func face_direction(node: Node2D, direction: Vector2) -> void: # IMPLEMENTED
	if sign(direction.x) == 1.0:
		node.flip_h = false
	else:
		node.flip_h = true
func teleport_to(node: Node2D, pos: Vector2) -> Vector2: # IMPLEMENTED
	var old_pos: Vector2 = node.position
	node.position = pos # new position
	return old_pos # should be original position in case

# Dialogue Functions
@warning_ignore("unused_parameter")
func speak(dialogue: String, speech_bank_idx: int = -1, manual_dialogue: DialogueComponent = null) -> void:
	push_error("speak() must be implemented by subclass.")
	pass  # speech bank idx is in the case the character does have a speech component
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
	
# misc

@warning_ignore("unused_parameter")
func get_camera() -> Camera2D:
	push_error("get_camera() must be implemented by subclass.")
	return null

func wait(seconds: float) -> void: # IMPLEMENTED
	await get_tree().create_timer(seconds).timeout
func event_to_string(event: Event) -> String: # IMPLEMENTED
	match event:
		Event.CORRECT: return "correct"
		Event.INCORRECT: return "incorrect"
		Event.PAUSE: return "pause"
		Event.SLOW: return "slow"
		Event.TIME_LOW: return "time_low"
		_: return "unknown"

	
	
