class_name UIComponent
extends Control

signal answer_correct(answer)
signal answer_incorrect(answer)


## requires parent to have implementation for 
	## hint and answer	

@export_category("Parent")
@export var level_handler: Handler

@export_category("UI Nodes")
@export var hint_btn: TextureButton
@export var settings_btn: TextureButton
@export var answer_btn: TextureButton
@export var stats_btn: TextureButton
@export var restart_btn: TextureButton
@export var hint_bulbs: HBoxContainer
@export var answer: AnswerComponent

@export var time_label: Label
@export var timer: Timer
@export var game_time: float = 300.0 # seconds

@export var audio: AudioStreamPlayer2D
@export var anim: AnimationPlayer

@export_category("UI Menus")
@export var settings_menu: Settings

@export_category("Preloads")
@export var hint_popup: PackedScene

var curr_level_resource # current level resource data for displaying hints
var current_hint: int = 0

func _ready():
	answer.answer_incorrect.connect(signal_incorrect)




# this is out of place, but it just makes the Mascot react to incorrect answers
func signal_incorrect(ans):
	level_handler.add_incorrect()

func _on_hint_pressed():
	anim.play("BulbPressed")
	audio.stream = load("res://Assets/Audio/lightbulb_sound.mp3")
	audio.play()
	
	hint_bulbs.get_child(current_hint).texture.region = Rect2(Vector2(0, 32), Vector2(32, 32))
	var hint_data: String = curr_level_resource.hints[current_hint]
	var hint: HintComponent = hint_popup.instantiate() as HintComponent
	hint.hint_text = hint_data
	# prevent index out of bounds
	if current_hint < len(curr_level_resource.hints) - 1:
		current_hint += 1
	
	get_tree().root.call_deferred("add_child", hint)
	
	
func _on_settings_pressed():
	settings_menu.open()


func _on_answer_ready_pressed():
	answer.curr_level_resource = curr_level_resource # replaced every time if the problem changes
	anim.play("AnswerPressed", -1, 2.0)
	audio.stream = load("res://Assets/Audio/ready.mp3")
	audio.play()
	answer.visible = true
	get_tree().paused = true
	answer.question_text.text = curr_level_resource.objective_type

func _on_stats_pressed():
	pass # Replace with function body.


func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_timer_timeout():
	if (game_time > 0):
		timer.start(1.0)
		time_label.text = str(game_time)
		game_time -= 1
