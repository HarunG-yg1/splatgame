extends Node
#var player : Player

#class_name SceneManager

var tp_coords : Vector2
#var loading_screen = preload("res://UI stuff/load.tscn")

var scene_path = "res://scene/"
var next_scene : String = ""
var flashback_res_filepath = ""

func change_scene(from, to_scene_name: String=next_scene):

	var full_path = scene_path + to_scene_name + ".tscn"
	var loading_screen = preload("res://UI/load.tscn").instantiate()
	loading_screen.next_scene_path = full_path
	print(loading_screen.next_scene_path)
	loading_screen.parameters = {}
	get_tree().current_scene.add_child(loading_screen)
