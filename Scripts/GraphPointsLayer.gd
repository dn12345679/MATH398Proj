class_name PointsLayer
extends GraphObject

enum LayerType {Axes, Point, Line, Grid}
@export var layer_type: LayerType


## Plots every single dot from 0 to the max width in steps of "1"
func _draw():
	for i in range(0, unit_px * width, unit_px):
		for j in range(0, -unit_px * height, -unit_px):
			draw_circle(Vector2(i, j), 1, get_intersection(i, j))

## Given 2 integer coordinates x, y in the plot, return Color.FIREBRICK
	## If it is intersected by Z = xX + yY, where Z is the Z_value, X is the 
	## X coefficient of the line, and Y is the Y coefficient of the line, 
	## For example, 5 = 3x + 5y, where x and y are the parameters.
	## Note that I do - instead of + because in code, negative is the up dir
func get_intersection(x: int, y: int) -> Color:
	var result =  (x_coeff * x / unit_px) - (y_coeff * y / unit_px)
	
	if abs(get_parent().z_value - result) < 0.1:
		return Color.FIREBRICK
	return Color.WHITE
