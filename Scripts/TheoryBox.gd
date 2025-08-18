class_name TheoryBox
extends StaticBody2D


## IGNORE: Warning for collision shapes is fake; I add collision shapes below


@export_category("Properties")
@export var extents_length: float = 2
@export var unit_px: float = 32

@export_category("Preloads")
@export var wall_texture: Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_box(extents_length)


func initialize_box(len: float) -> void:
	for child in get_children():
		child.queue_free()  # reset
		
	var dir: Array[Vector2] = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	var texture: Texture2D = load("res://Assets/Images/quincunx_bar.png")
	for i in range(4):
		var collider: CollisionShape2D = CollisionShape2D.new()
		var shape: RectangleShape2D = RectangleShape2D.new()
		var sprite: Sprite2D = Sprite2D.new()
		sprite.texture = texture
		
		if i % 2 == 0:
			shape.size = Vector2(unit_px * extents_length, unit_px * 0.02)
			sprite.scale = Vector2(extents_length, 0.02)
		else:
			shape.size = Vector2(unit_px * 0.02, unit_px * extents_length)
			sprite.scale = Vector2(0.02,extents_length)
		collider.shape = shape
		add_child(collider) 
		collider.add_child(sprite)
		
		collider.position = dir[i] * (32 * 0.02 + 32 * extents_length)/2 # not arbitrary, fact of rects
		
				
