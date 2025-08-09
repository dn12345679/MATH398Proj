class_name StatResource
extends Resource

@export var title: String
@export var description: String
@export var objective_type: String 
@export var completion_message: String
@export var reward_time: int = 0
@export var hints: Array[String]
@export var correct_answer: Array[String]

@export_category("Card Game")
var rand: Vector2i = Vector2i(-1, -1) # to fill with randoms
@export var card_draw: Array[Vector2i] # FOR FUTURE REFERENCE: 
									#     [0] is RANK, [1] is SUIT
@export var card_count: int
@export var replacement: bool

@export_category("Quincunx Game")
@export var allow_delete_pegs: bool = false
@export var max_peg_delete: int = int(allow_delete_pegs)

