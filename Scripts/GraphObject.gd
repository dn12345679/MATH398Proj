class_name GraphObject
extends Control

@export_category("Graph Properties")
@export var unit_px: float = 8.0
@export var width: int = 20
@export var height: int = 20
@export var colored_dots: bool = false

@export_category("Line Properties")
@export var x_coord: Vector2 = Vector2.ZERO
@export var y_coord: Vector2 = Vector2.ZERO
@export var z_value: float

@export var x_coeff: int = 3
@export var y_coeff: int = 5

@export_category("Nodes")
@export var z_slider: HSlider
@export var axes_layer: AxesLayer
@export var points_layer: PointsLayer
@export var line_layer: LineLayer

func set_graph_dimensions(width: int, height: int) -> void:
	pass

## for z = ay + bx, return the coordinates associated with x and y at 0
func get_line(x, y, z) -> Array[Vector2]:
	return [Vector2(z/x, 0), -Vector2(0, z/y)]

func _on_z_value_drag_ended(value_changed):
	z_value = z_slider.value
	z_slider.get_node("Label").text = str("Z-value: " + str(z_value))
	
	line_layer.x_coord = get_line(x_coeff, y_coeff, z_value)[0]
	line_layer.y_coord = get_line(x_coeff, y_coeff, z_value)[1]
	
	line_layer.queue_redraw()
	points_layer.queue_redraw()
