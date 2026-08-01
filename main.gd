extends Node2D

@onready var trail : Node = $fx_trail
@onready var hurttrail : Area2D = $trail_hurt
@onready var player : Player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trail.init(player)
	hurttrail.init(player)
	pass # Replace with function body.
