class_name defense_box extends Node2D
@onready var sprite = $Sprite2D
var arrow_node = preload("res://Misc/arrow.tscn")
var arrowArr : Array[arrow]
var current_arrows : Array[arrow]
var player : Player 
var time_on : float
var cardinal_dir : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.


func add(hit_type : int , hit_time : float , hit_owner : Enemy):
	visible = true
	var new_arrow = arrowArr_findFirstAvail()
	if new_arrow == null:
		new_arrow  = arrow_node.instantiate()
		add_child(new_arrow)
		arrowArr.append(new_arrow)

	new_arrow.init(hit_owner,hit_type,hit_time)
	#print(arrowArr.size())
	
	#new_arrow.visible = true

func remove(hit_owner : Enemy):
	for i in arrowArr:
		if i.enemy_Owner == hit_owner:
			i.alive = false
			i.process_mode = Node.PROCESS_MODE_DISABLED
			i.visible = false
	

	
func arrowArr_findFirstAvail()->arrow:
	for i : arrow in arrowArr:
		if !i.alive:
		#	visible = true
			return i
	return null

func check_empty():
	for i in arrowArr:
		if i.alive:
			
			return 
	visible = false

func find_arrow_type(type:int):
	var found : bool = false
	for arrow_node : arrow in current_arrows:
		if arrow_node.enemy_attk_type == type:
			found = true
	return found

func set_arrow_type(type:int)->void:
	
	for arrow_node : arrow in current_arrows:
		if arrow_node.enemy_attk_type == type:
			arrow_node.hit = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if abs(get_global_mouse_position() - global_position).x > abs(get_global_mouse_position() - global_position).y:
			if (get_global_mouse_position() - global_position).x > 0:
				cardinal_dir = Vector2.RIGHT
				print("right")
			else:
				cardinal_dir = Vector2.LEFT
				print("left")
		else:
			if (get_global_mouse_position() - global_position).y > 0:
				cardinal_dir = Vector2.DOWN
				print("down")
			else:
				cardinal_dir = Vector2.UP
				print("up")
		sprite.look_at(global_position + cardinal_dir )

func _on_area_entered(area: arrow) -> void:
	current_arrows.append(area)
	pass # Replace with function body.


func _on_area_exited(area: arrow) -> void:
	
	if area in current_arrows:
		
		current_arrows.erase(area)
	check_empty()
	if player.i_time <= 0 and !area.hit and area.alive and area.visible:
		area.animSprite.play("miss")
		if area.enemy_Owner != null:
			#player.velocity -=  (area.enemy_Owner.global_position - player.global_position)
			player.missed = true

	elif area.alive and area.visible:
		player.missed = false
		
		area.animSprite.play("hit")
	area.alive = false
	#area.process_mode = Node.PROCESS_MODE_DISABLED
	
	#pass # Replace with function body.
