class_name QuincunxHandler
extends Handler

@export_category("Nodes")
@export var spawn_handler: Control
@export var chart: DistributionChart
@export var audio: AudioStreamPlayer2D
@export var b_counter: Area2D
@export var obj: Label
@export var levels: Array[StatResource] # store level data 
	## IMPORTANT: levels must exist for the game to be played
var curr_level = 0

@export var quincunx_ball: PackedScene

func _ready():
	super._ready()
	audio.play()
	handle_level(levels[curr_level])
	game_ui.curr_level_resource = levels[curr_level]



## handles card drawing, setting scene, etc
func handle_level(res: StatResource):

	obj.text = res.objective_type
	objective.update_text(res.description)

# spawn a quincunx
func _on_spawn_ball_pressed():
	var ball: QuincunxBall2D = quincunx_ball.instantiate()
	spawn_handler.get_node("QuincunxSpawn").call_deferred("add_child", ball)


# to queue free the balls and reduce lag, and for plotting
func _on_ball_counter_body_entered(body):
	chart.add_point(body.global_position)
	b_counter.get_node("AudioStreamPlayer2D").play()
	body.queue_free()
