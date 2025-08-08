class_name CardComponent
extends Control

@export_category("Card Info")
@export var card_rank: float = 0 # 0 = Ace, 12 = King
@export var card_suit: float = 0 # 0 = Hearts, 1 = Diamonds, 2 = Spades, 3 = Clubs
var card_width: float = 48.0
var card_height: float = 64.0

@export_category("Nodes")
@export var card_front: Sprite2D
@export var card_back: Sprite2D
@export var anim: AnimationPlayer
@export var audio: AudioStreamPlayer2D


@export_category("Misc")
@onready var c_flip = preload("res://Assets/Audio/card_flip.mp3")
@onready var c_flip2 = preload("res://Assets/Audio/card_flip2.mp3")
var card_hovered: bool = false # boolean flag for card selection
var card_selected: bool = false # separate flag from hovered, for actual playing

# further actions handled by parent
func _input(event):
	if event is InputEventMouseButton and event.is_action_released("mouse_left"):
		if card_hovered and !anim.is_playing(): 
			# only select cards who are currently being hovered over
			if !card_selected:
				card_selected = true
				anim.play("Selected", -1, 2.0)
				play_sound(c_flip2, 0)
				
				return self
			else:
				anim.play_backwards("Selected")
				card_selected = false


func _ready():
	card_front.region_rect = Rect2(
		Vector2(card_width * card_rank, card_height * card_suit), 
		Vector2(card_width, card_height))
	anim.play("CardShake", -1, 2.0)


func get_rank() -> float:
	return card_rank
func get_suit() -> float: 
	return card_suit

# rank from low card ace
# suit from HDSC
func compare_to(card: CardComponent) -> int:
	var val: int = 0 # they are the same
	if (card.get_rank() < get_rank()):
		val = 1
	elif (card.get_rank() > get_rank()):
		val = -1
	else:
		if (card.get_suit() > get_suit()):
			val = 1
		else:
			val = -1
	return val

func toggle_front() -> void:
	card_front.visible = !card_front.visible
func toggle_back() -> void:
	card_back.visible = !card_back.visible

func _on_hover_block_mouse_entered():
	card_hovered = true # bool flag for card selection
	anim.play("CardShake", -1, 3.0)	
	play_sound(c_flip, -25)

	
func _on_hover_block_mouse_exited():
	card_hovered = false # bool flag for card selection

func play_sound(file: Object, volume: float, pitch: float = 1.0):
	audio.stream = file
	audio.volume_db = volume
	audio.pitch_scale = pitch
	audio.play()	
