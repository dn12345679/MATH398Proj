class_name AnswerComponent
extends Control

signal answer_correct(answer)
signal answer_incorrect(answer)

@export_category("Nodes")
@export var question_text: Label
@export var answer_box: TextEdit

@export var curr_level_resource: Resource


	

func check_answer():
	var ans2str: String = str(answer_box.text).strip_edges()
	if len(curr_level_resource.correct_answer) == 0 or  ans2str in curr_level_resource.correct_answer:
		answer_correct.emit(ans2str)
	else:
		answer_incorrect.emit(ans2str)
	close()
	



func _on_submit_pressed():
	check_answer()
func _on_back_pressed():
	
	close()

func close():
	get_tree().paused = false
	visible = false
