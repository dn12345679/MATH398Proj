class_name CameraSequence

## Intended to encompass all movement information for camera sequencing
## DEPENDENCY: must have Dynamic Camera

@export_category("Sequence Specification")
@export var positions: Array[Vector2]
@export var durations: Array[float]

@export var speed: float = 1.0 # default speed

var curr_idx: int = 0 # always start at 1 unless otherwise instructed
var max_idx: int # set in init

@warning_ignore("shadowed_variable")
func _init(positions, durations):
	self.positions = positions
	self.durations = durations
	if (len(positions) != len(durations)):
		print("error in length mismatch for CameraSequence")
	max_idx = len(positions) # they should be equal

## GET/SET position
func get_position(index: int) -> Vector2:
	return positions[index]
func set_position_at(index: int, new_position: Vector2) -> void:
	positions[index] = new_position

## GET/SET duration
func get_duration(index: int) -> float:
	return durations[index]
func set_duration_at(index: int, new_duration: float) -> void:
	durations[index] = new_duration

## GET/SET speed
func get_speed() -> float:
	return speed
func set_speed(new_speed: float) -> void:
	speed = new_speed
