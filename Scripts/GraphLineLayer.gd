class_name LineLayer
extends GraphObject

enum LayerType {Axes, Point, Line, Grid}
@export var layer_type: LayerType


func _draw():
	draw_line(x_coord * unit_px, y_coord * unit_px, Color.GREEN, 1.0)
