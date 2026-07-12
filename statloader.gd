extends Node
var player : Player
var player_stats : Dictionary = {"current_health" : 20 ,"max_health" : 20 , "bullets_left" : 6}
var player_stats_copy : Dictionary = {"current_health" : 20 ,"max_health" : 20 , "bullets_left" : 6}
var kill_count : int = 0
var arr_of_blood : Array[blood_puddle.puddle_colors]
func get_statsfromLoader(player:Player):
	

	player.current_health = player_stats["current_health"]
	player.max_health = player_stats["max_health"]
	player.arr_of_blood = arr_of_blood
	player.gun.current_ammo = player_stats["bullets_left"]

func set_statsToLoader(player:Player):
	print("fart")
	player_stats["current_health"] = player.current_health
	player_stats["max_health"] = player.max_health
	arr_of_blood = player.arr_of_blood
	player_stats["bullets_left"] = player.gun.current_ammo
	
func reset():
	player_stats = player_stats_copy
