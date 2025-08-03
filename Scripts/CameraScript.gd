class_name DynamicCamera
extends Node2D

## Camera for the game, intended to handle all movement, from the positioning to the zoom
## Dependency: Uses the CameraSequence.gd script to handle interactions

@export_category("Camera Properties")
@export var node_follow: Node2D
@export var follow_speed: float = 0.7
@export var camera_center: Vector2 = Vector2.ZERO

@export var zoom_amount: float = 1.0:
	set(value):
		zoom_amount = value
		if cam:
			cam.zoom = Vector2(zoom_amount, zoom_amount)
			
@export var smoothing: float = 5.0
@export var cam: Camera2D # need to access

var sequences: Array[CameraSequence] = [] # Camera will move as long as this is populated
var last_played_idx: int = -1



func _ready():
	# set if null
	if cam == null:
		cam = get_node_or_null("Camera2D") 
	
	cam.zoom = Vector2(zoom_amount, zoom_amount) 
	cam.position_smoothing_speed = smoothing
	cam.rotation_smoothing_speed = smoothing
	cam.position = camera_center
	
## Handles camera following
func _physics_process(_delta):
	# follow if node is available and there is no more sequences to transition
	if node_follow != null && last_played_idx >= len(sequences):
		position = position.lerp(node_follow.position, follow_speed)
	
## Creates a 'camera sequence' object and adds it to the active queue. 
## Intended to be called by outside handlers.
## A 'camera sequence' consists of 3 components: The positions, the duration for each position,
func create_sequence(cam_pos_arr: Array[Vector2], cam_dur_arr: Array[float]) -> void:
	var new_camseq = CameraSequence.new(cam_pos_arr, cam_dur_arr)
	sequences.append(new_camseq)
	if (last_played_idx < len(sequences)):
		play_sequence_at(sequences[last_played_idx], 0)  # start from frame 1	
		last_played_idx += 1 # increment the queue
		

## plays the sequence starting from the Sequence's first frame if idx = 0
func play_sequence_at(seq: CameraSequence, idx: int) -> void:
	if idx >= seq.length():
		return  # finished sequence

	var target_position: Vector2 = seq.get_position(idx)
	var duration: float = seq.get_duration(idx)

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_position, seq.get_speed())
	await tween.finished  # waits until the tween is done
	await get_tree().create_timer(duration).timeout

	# Recursively play next frame in sequence
	play_sequence_at(seq, idx + 1)
