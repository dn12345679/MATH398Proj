class_name QuincunxBall2D
extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var rand_dir = [-1, 1].pick_random()
	var rand_offset = randf_range(1, 7)
	position.x += rand_offset * rand_dir



# random
func _on_body_entered(body):
	var randbounce = randf_range(-0.5, 0.5)
	var impulse = Vector2(randbounce * 130, -20)
	
	#apply_impulse(impulse, impulse)
