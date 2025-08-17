class_name AxesLayer
extends GraphObject
	
enum LayerType {Axes, Point, Line, Grid}
@export var layer_type: LayerType


func _draw():
	draw_line(Vector2.ZERO, Vector2(0, -height * unit_px), Color.BLACK, 2.0)
	draw_line(Vector2.ZERO, Vector2(width * unit_px, 0), Color.BLACK, 2.0)			

