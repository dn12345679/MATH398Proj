class_name DialogueEntry
extends Resource

@export var level: int = 0 # based on Global.curr_level_idx
@export var id: int = 0 # represents the "speech stage" it appears
@export var dialogue: String = "" # line to be spoken
@export var location: Vector2 = Vector2.ZERO# if the speaker must be moved
@export var duration: float = 1.0
@export var mood: String = "Wave"
