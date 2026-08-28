extends Area2D


var player : Player
var index : int = 0
var coll_arr : Array[CollisionShape2D]

@onready var timer : Timer = $Timer
func _ready() -> void:
	for i : Object in get_children():
		if i is CollisionShape2D:
			coll_arr.append(i)
			

func init( plyr:Player,emit : bool = false):
	
	plyr.start_trail.connect(start_trail)
	
	if emit:
		plyr.start_trail.emit(plyr)
func get_box(coll : CollisionShape2D):
	coll.disabled = false
	
	coll.global_position = player.global_position -player.velocity.normalized() *20
	if player.velocity.length()/(coll.shape.size.x * 8) > 1:
		coll.scale.x =  player.velocity.length()/(coll.shape.size.x * 8)
	else:
		coll.scale.x =  0.75
	if index ==0:
		coll.look_at(player.global_position + player.velocity)
	else:
		coll.look_at(coll_arr[index-1].global_position)
	
	
	
func start_trail(plyr):
	player = plyr
	index = 0
	process_mode = Node.PROCESS_MODE_INHERIT
	get_box(coll_arr[index])
	index += 1
	timer.start(0.1)
	
		
		

func _on_timer_timeout() -> void:

	if index < coll_arr.size():
		if index >= 2:
			coll_arr[index-2].disabled = true
		get_box(coll_arr[index])
		index += 1
		timer.start(0.1)
	elif player.attack_shape.disabled:
		for coll : CollisionShape2D in coll_arr:
			coll.disabled = true
			player = null
			process_mode = Node.PROCESS_MODE_DISABLED




func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Enemy and player != null and !player.attack_shape.disabled:
		
		player._on_attack_box_body_entered(body)
