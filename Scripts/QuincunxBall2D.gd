class_name QuincunxBall2D
extends RigidBody2D

@export_category("Nodes")
@export var audio: AudioStreamPlayer2D
@export var initial_position_distribution: Array[int] = [-1, 1]
@export var initial_offset: float = 0

# to simulate a real quincunx, I do a 50/50 split from 2-7 positions left to right
func _ready():
	var rand_dir = initial_position_distribution.pick_random()
	var rand_offset = randf_range(2, 7) + initial_offset
	position.x += rand_offset * rand_dir
	audio.play()
