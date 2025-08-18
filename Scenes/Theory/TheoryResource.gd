class_name TheoryResource
extends Resource

@export var title: String
@export var description: String
@export var objective_type: String 
@export var completion_message: String
@export var reward_time: int = 0
@export var hints: Array[String]
@export var correct_answer: Array[String]

@export_category("Coin Problem")
@export var num_coins: int = 2
@export var denominations: Array[int] = [3, 5]
@export var sum_coin_visible: bool = false
@export var graph_visible: bool = false

@export_category("Pizza Problem")
@export var max_points: int = 6 # should be a multiple of 2

@export_category("Square Problem")
@export var max_cubes: int = 4
@export var box_dimension: float = 2
@export var dropdown_visible: bool = false
