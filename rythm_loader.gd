extends Node
#var daddy_node :CanvasLayer
var player : Player
var hitlineScene = preload("res://Misc/defense.tscn")
var  hitline : defense_box
func addTo_hitline(hit_arr : Array[int_float_pair] , hit_owner : Enemy):
	var acc : float = 0
	if hitline == null:
		_show_attack_box()
	for i : int in range(hit_arr.size()):
		if hit_arr[hit_arr.size() - i - 1].time >= 0.0:
			
			acc += hit_arr[hit_arr.size() - i - 1].time
			#var time = acc
			hitline.add( hit_arr[hit_arr.size() - i - 1].number,acc,hit_owner)
		
		print(acc,"nroon")


func interrupt(hit_owner : Enemy):
	if hitline == null:
		_show_attack_box()
	hitline.remove(hit_owner)


func _show_attack_box():
	hitline = hitlineScene.instantiate()
	hitline.player = player
	player.add_child(hitline)

func find_attkType(type : blood_puddle.puddle_colors)->bool:
	if hitline == null:
		_show_attack_box()
	return hitline.find_arrow_type(type)

func setHit_attkType(type : blood_puddle.puddle_colors)->void:
	hitline.set_arrow_type(type)
