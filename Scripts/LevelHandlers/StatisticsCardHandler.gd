class_name CardHandler
extends Handler

@export_category("Nodes")
@export var gb: Node
@export var hand: HBoxContainer
@export var c_scene: PackedScene
@export var audio: AudioStreamPlayer2D
@export var obj: Label

@export var levels: Array[StatResource] # store level data

@export var cards_drawn: Array[Vector2i] = []

func _ready():
	super._ready()
	audio.play()
	if Global.curr_level_idx < Global.max_level_idx and Global.curr_level_idx < len(levels):
		handle_level(levels[Global.curr_level_idx])
		game_ui.curr_level_resource = levels[Global.curr_level_idx]
	else:
		super.handle_all_levels_complete()

## handles card drawing, setting scene, etc
func handle_level(res: StatResource):
	initial_hand(res.card_draw, res.card_count, res.replacement)
	obj.text = res.objective_type
	objective.update_text(res.description)

## Draws 'num' cards to the 'hand', with/wout 'replacement'
func initial_hand(rs: Array[Vector2i], num: int, replacement: bool) -> void:
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
		
		hand.add_child(draw_card_with_rs(rank, suit))
		
		cards_drawn.append(Vector2i(rank, suit))

func draw_card_with_rs(rank: int, suit: int) -> CardComponent:
	var card: CardComponent = c_scene.instantiate() as CardComponent
	card.card_rank = rank
	card.card_suit = suit
	cards_drawn.append(Vector2i(rank, suit))
	return card

func draw_random_card(possible_rank, possible_suit) -> CardComponent:
	var res: StatResource = levels[Global.curr_level_idx]
	var remaining_rank = possible_rank
	var remaining_suit = possible_suit
	

	var rank = randi_range(0, 12) if res.replacement else remaining_rank[randi() % remaining_rank.size()]
	var suit = randi_range(0, 3) if res.replacement else remaining_suit[randi() % remaining_suit.size()]
	
	return draw_card_with_rs(rank, suit)
	

func on_discard_pressed():
	var selected_cards = get_selected_cards()
	var num_to_replace = selected_cards.size()
	
	# Remove selected cards
	for card in selected_cards:
		card.queue_free()
	
	# Add replacements after the frame (when old cards are actually gone)
	await get_tree().process_frame
	call_deferred("add_replacement_cards", num_to_replace)

func add_replacement_cards(count: int):
	for i in count:
		hand.add_child(draw_random_card(range(0, 13), range(0, 4)))

func get_selected_cards() -> Array[CardComponent]:
	var cards_selected: Array[CardComponent] = []
	for i in hand.get_children():
		if i.card_selected:
			cards_selected.append(i)
	return cards_selected
