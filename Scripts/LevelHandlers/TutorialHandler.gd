class_name TutorialHandler
extends Handler

signal stage_changed

func increment_stage() -> void:
	speech_stage += 1
	emit_signal("stage_changed") 
func decrement_stage() -> void:
	speech_stage -= 1
	emit_signal("stage_changed")
