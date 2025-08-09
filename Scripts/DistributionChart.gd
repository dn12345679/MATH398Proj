class_name DistributionChart
extends Node2D

@export_category("Plot fields")

@export var sample_points: Array = [] # array of anything
@export var num_bins: float = 6.0
@export var bin_spacing: float = 72.0 # 32/0.75 * 3 (weird but it works)
@export var bin_radius: float = 36.0 
@export var tick_size: float = 10.0 # 4 pixel per 1

@export var min_value: float = -176.0 # expected minimum (tested)
@export var max_value: float = 184.0 # expected maximum (-176 + num_bins * bin_spacing)

var bins = [] # an array of zeros, with num_bin zeros

func _ready():
	for i in range(num_bins):
		bins.append(0) # count of 0 at each "bin"



func _draw():	
	var initial_position: Vector2 = Vector2.ZERO
	for i in range(num_bins):
			
		var points = PackedVector2Array([
			Vector2(initial_position.x, -initial_position.y),
			Vector2(initial_position.x + bin_spacing, -initial_position.y),
			Vector2(initial_position.x + bin_spacing, -tick_size * bins[i]),
			Vector2(initial_position.x, -tick_size * bins[i])
		])
		draw_colored_polygon(points, Color.BLUE)
		
		initial_position.x += bin_spacing 


# how to draw a bin: Find 4 points, initial, initial.x + bin_size * tick_size,
				# initial.y + tick_size * number of recorded sample points in range of bin
				# initial.y + tick_size * number of recorded sample points in range + 
					#initial.x + bin_size * tick_size
# ASSUMES THAT POINT IS A VECTOR2
func add_point(point: Vector2) -> void:
	sample_points.append(point.x)
	update_min(point.x)
	update_max(point.x)
	add_to_bin(point.x)
	
func update_min(val) -> void:
	if min_value == null || val < min_value:
		min_value = val
func update_max(val) -> void:
	if max_value == null || val > max_value:
		max_value = val

# automatically adds the ball to the nearest bin
func add_to_bin(val) -> void:
	for i in range(num_bins):
		var bin_center = min_value + i * bin_spacing
		if val < bin_center + bin_radius and val > bin_center - bin_radius:
			bins[i] += 1
			queue_redraw()
			return
