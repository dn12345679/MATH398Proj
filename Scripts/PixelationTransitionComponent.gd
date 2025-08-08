class_name PixelationTransitionComponent
extends Node2D

var mat: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	
	visible = true

	
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_method(
		set_pixelation,
		4.0,
		1.0,
		1.0
	)
	tween.tween_method(
		set_alpha,
		0.4,
		0.0,
		1.0
	)
	await tween.finished
	queue_free()


func set_pixelation(val: float) -> void:
	$ColorRect.material.set_shader_parameter("pixelation_amount", val)

func set_alpha(val: float) -> void:
	$ColorRect.material.set_shader_parameter("alpha_amount", val)
