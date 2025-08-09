class_name QuincunxBall2D
extends RigidBody2D


# to simulate a real quincunx, I do a 50/50 split from 2-7 positions left to right
func _ready():
	var rand_dir = [-1, 1].pick_random()
	var rand_offset = randf_range(2, 7)
	position.x += rand_offset * rand_dir
