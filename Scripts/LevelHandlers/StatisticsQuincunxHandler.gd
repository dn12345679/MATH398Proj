class_name QuincunxHandler
extends Handler

@export_category("Nodes")
@export var spawn_handler: Control
@export var chart: DistributionChart


@export var quincunx_ball: PackedScene

func _ready():
	print(get_node("MascotComponent").position)


# spawn a quincunx
func _on_spawn_ball_pressed():
	var ball: QuincunxBall2D = quincunx_ball.instantiate()
	spawn_handler.get_node("QuincunxSpawn").call_deferred("add_child", ball)


# to queue free the balls and reduce lag, and for plotting
func _on_ball_counter_body_entered(body):
	chart.add_point(body.global_position)
