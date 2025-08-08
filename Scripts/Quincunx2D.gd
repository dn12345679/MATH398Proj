class_name Quincunx2D
extends Node2D

## Represents a Quincunx2D Object. Quincunx2D pegs naturally order from initial position downwards

@export_category("Quincunx2D")
@export var layers: int = 5 # default 2 layer quincunx
@export var spacing: float = 32.0 # default 32 pixels apart
@export var radius: float = 6.0
@export var initial_peg_center: Vector2 = Vector2.ZERO

@onready var peg_img = preload("res://Assets/Images/quincunx_peg.png")
@onready var ball_img = preload("res://Assets/Images/quincunx_ball.png")
@onready var sidebar_img = preload("res://Assets/Images/quincunx_bar.png")

func _ready():
	initialize_pegs(spacing, layers)
	include_sidebar(1)
	include_sidebar(-1)

func initialize_pegs(px_spacing: float, px_layers: int):
	var offset: Vector2 = initial_peg_center # set peg 1
	# since range is noninclusive ; i do +1 so it makes more sense
	for i in range(layers + 1):
		offset.y += px_spacing * i # offset the y for each layer
		offset.x -= px_spacing * i * 0.75 # constant for initial offset
		for j in range(i):
			create_peg(offset)
			offset.x += px_spacing * 1.5 # constant for after offset ; 
		offset = initial_peg_center
	
func create_peg(pos: Vector2):
	var peg: StaticBody2D = StaticBody2D.new()
	var peg_collider: CollisionShape2D = CollisionShape2D.new()
	var sprite: Sprite2D = Sprite2D.new()
		# set the sprite features first
	sprite.texture = peg_img 
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	peg_collider.shape = CircleShape2D.new()
	
	# create peg
	peg.add_child(peg_collider)
	peg.add_child(sprite)	
	
	# add it to tree at the position
	add_child(peg)
	peg.position = pos

func include_sidebar(left_or_right: int):
	var bar: StaticBody2D = StaticBody2D.new()
	var collider: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	var sprite: Sprite2D = Sprite2D.new()
	
	sprite.texture = sidebar_img
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
	sprite.scale = Vector2(1, 20)
	shape.size = Vector2(20, 800)
	collider.shape = shape
	bar.add_child(collider)
	
	#bar.add_child(sprite)
	
	bar.rotation_degrees = rad_to_deg(atan2(abs(spacing * 0.75 * 1.5),abs(1.5*spacing))) * left_or_right
	
	add_child(bar)
	if left_or_right > 0:
		bar.position.x -= spacing * 0.75 * (layers - 3.25)
	else:
		bar.position.x -= spacing * left_or_right * -0.25
