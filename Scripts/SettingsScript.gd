class_name Settings
extends Control

@export_category("Setting Nodes")
@export var audio: AudioStreamPlayer2D

var menu_open: bool = false


func _ready():
	pass

func open():
	menu_open = true
	visible = menu_open
	get_tree().paused = menu_open
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	audio.play() # play the pause theme 1 time]

func close():
	menu_open = false
	
	get_tree().paused = menu_open
	var tween: Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	visible = menu_open
	audio.stop() # play the pause theme 1 time]	

## Handles volume changes for music and dialogue in the pause menu
func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)
func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_exit_menu_pressed():
	close()
