class_name CardHandler
extends Handler

@export_category("Nodes")
@export var gb: Node
@export var hand: HBoxContainer
@export var c_scene: PackedScene
@export var audio: AudioStreamPlayer2D
@export var obj: Label

@export var levels: Array[StatResource] # store level data
var curr_level: int = 0 # iterate over levels array

func _ready():
	audio.play()
	handle_level(levels[curr_level])
	game_ui.curr_level_resource = levels[curr_level]

## handles card drawing, setting scene, etc
func handle_level(res: StatResource):
	draw_cards(res.card_draw, res.card_count, res.replacement)
	obj.text = res.objective_type
	objective.update_text(res.description)

## Draws 'num' cards to the 'hand', with/wout 'replacement'
func draw_cards(rs: Array[Vector2i], num: int, replacement: bool) -> void:
	var remaining_rank = range(0, 13) # for drawing without replacement
	var remaining_suit = range(0, 4) # for drawing without replacement
	
	for i in range(num):
		var rank = randi_range(0, 12) if replacement else remaining_rank[randi() % remaining_rank.size()]
		var suit = randi_range(0, 3) if replacement else remaining_suit[randi() % remaining_suit.size()]
		
		# if the RES file has a fixed draw
		if i < len(rs):
			rank =  rs[i][0] if (rs[i][0] >= 0) else rank
			suit =  rs[i][1] if (rs[i][1] >= 0) else suit
		
		# erase even if replacement just to keep track
		remaining_rank.erase(rank)
		remaining_suit.erase(suit)

		var card: CardComponent = c_scene.instantiate() as CardComponent
		card.card_rank = rank
		card.card_suit = suit
		hand.add_child(card)
