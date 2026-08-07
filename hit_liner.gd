class_name defense_box extends Node2D

var arrow_node = preload("res://Misc/arrow.tscn")
var arrowArr : Array[arrow] = []
var current_arrows : Array[arrow] = []
var player : Player 
var time_on : float
var cardinal_dir : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.


func add(hit_type : Color , hit_time : float , hit_owner : Enemy):
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
			i.hit = false
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
		if i.visible:
			
			return 
	visible = false

func find_arrow_type(type: Color):
#	var found : bool = false
#	print(current_arrows.size(),"size")
	for arrow_node : arrow in current_arrows:
		
		if RythmLoader.check_similiar_colour(arrow_node.enemy_attk_type,type):
			return true
	return false

func set_arrow_type(type: Color)->void:
	
	for arrow_node : arrow in current_arrows:
		if RythmLoader.check_similiar_colour(arrow_node.enemy_attk_type,type):
			arrow_node.hit = true



func _on_area_entered(area: arrow) -> void:
	current_arrows.append(area)
	#print(area.enemy_attk_type,"enemy_attk_type")
	pass # Replace with function body.


func _on_area_exited(area: arrow) -> void:
	
	if area in current_arrows:
		
		current_arrows.erase(area)
	check_empty()
	if player.i_time <= 0 and !area.hit and area.alive and area.visible:
		area.animSprite.play("miss")

		area.modulate = Color.WHITE
		#player.velocity -=  (area.enemy_Owner.global_position - player.global_position)
		player.missed = true

	elif area.alive and area.visible:
		player.missed = false
		area.modulate = Color.WHITE
		area.animSprite.play("hit")
	area.alive = false
	#area.process_mode = Node.PROCESS_MODE_DISABLED
	
	#pass # Replace with function body.
