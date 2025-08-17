class_name CoinHandler
extends Handler


@export_category("Info")
@export var audio: AudioStreamPlayer2D
@export var obj: Label
@export var levels: Array[TheoryResource] # store level data 
	## IMPORTANT: levels must exist for the game to be played
@export var wallet: HBoxContainer
@export var sum_coin: TheoryCoin
@export var graph: GraphObject

@export var current_value: int = 0
	
@export_category("Instances")
@export var coin_scene: PackedScene



 
func _ready():
	super._ready()
	audio.play()
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		super.handle_all_levels_complete()	


## handles card drawing, setting scene, etc
func handle_level(res: TheoryResource):
	
	obj.text = res.objective_type
	objective.update_text(res.description) # handler main class
	sum_coin.visible = res.sum_coin_visible
	graph.visible = res.graph_visible
	
	for i in range(res.num_coins):
		var coin: TheoryCoin = coin_scene.instantiate() as TheoryCoin
		coin.set_denomination(res.denominations[i])
		coin.increment.connect(_on_increment)
		coin.decrement.connect(_on_decrement)
		wallet.add_child(coin)
		
	
func _on_increment(value) -> void:
	current_value += value
	_update_coin()

func _on_decrement(value) -> void:
	current_value = 0
	_update_coin()

func _update_coin() -> void:
	sum_coin.set_denomination(current_value)
