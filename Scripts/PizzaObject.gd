class_name PizzaObject
extends Sprite2D

@export_category("Pizza Nodes")
@export var audio: AudioStreamPlayer2D
@export var point_audio: AudioStream
@export var cut_audio: AudioStream

@export_category("Slice Properties")
@export var pizza_radius: int = 500

@export var selected_points: Array[Vector2] = []
@export var connected_lines: Array[Vector2] = []
@export var max_points: int = 6
@export var center: Vector2 = Vector2.ZERO

func _ready():
	pass

func _input(event):
	_on_pizza_point_clicked(event)	

func _on_pizza_point_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and len(selected_points) < max_points:
			var local_mouse_pos = get_local_mouse_position()
			if (local_mouse_pos - position).length() < pizza_radius:
				var direction = (local_mouse_pos - center).normalized()
				var edge_point = center + direction * pizza_radius
				selected_points.append(edge_point)
				queue_redraw()
		
		# delete points
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if len(selected_points) >= 1:
				selected_points.remove_at(len(selected_points) - 1)
				queue_redraw()
				
func _draw():
	for point: Vector2 in selected_points:
		draw_circle(point, 16, Color.BLACK)
		audio.stream = point_audio
		audio.play()
	if len(selected_points) % 2 == 0 && len(selected_points) != 0:

		for i in range(0, len(selected_points), 2):
			draw_line(selected_points[i], selected_points[i + 1], Color.BLACK, 4)
		connected_lines.append(selected_points[1] - selected_points[0])
		audio.stream = cut_audio
		audio.play()	
