class_name TheorySquare
extends RigidBody2D

enum States { UNPICKED, PICKED }

@export var click_area: TextureRect
@export var collider: CollisionShape2D

# "Box Properties"
var is_steady = false # set to true when angular velocity is approx 0
		# useful for checking if all cubes are still
var is_dragging = false

func _ready():
	click_area.connect("gui_input", _on_click_area_gui_input)

func _on_click_area_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		set_drag_state(event.pressed)


func set_drag_state(state: bool) -> void:
	match state:
		true:
			is_dragging = true
			set_collision_mask_value(1, false)
			gravity_scale = 0		
		false:
			is_dragging = false
			set_collision_mask_value(1, true)
			gravity_scale = 0.5	

func _integrate_forces(state):
	if is_dragging:
		var to_mouse = get_global_mouse_position() - global_position
		var dir = to_mouse.normalized()
		var spring_force = dir * 2000
		var damping = -state.linear_velocity * 10
		state.apply_central_force(spring_force + damping)
		
	if !is_equal_approx(angular_velocity, 0):
		modulate.a = 0.5
		is_steady = false
	else:
		modulate.a = 1
		is_steady = true


