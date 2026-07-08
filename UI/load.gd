extends CanvasLayer # loading

@export_file("*.tscn") var next_scene_path: String
@onready var textrect = $Control/TextureRect


#@export var tips: Array[Dictionary] = [
#	{"title": "Make sure to complete the mission", "text": "When you complete your mission you will earn coins."},
#	{"title": "Play the game with full relax", "text": "Are you trying to speedrun this game? LOLOLOL"}
	
#]

var parameters: Dictionary
var loaded := false


func _ready():
	
	ResourceLoader.load_threaded_request(next_scene_path)

	
func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(textrect,"modulate:a" ,1, 2)
		set_process(false)
		
		await get_tree().create_timer(2).timeout
		loaded = true
		#%Label.text = "wait pls"
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		
		var new_node = new_scene.instantiate()
		#new_node.parameters = parameters"shader_parameter/blur_power"
		var current_scene = get_tree().current_scene
		get_tree().get_root().add_child(new_node)
		get_tree().current_scene = new_node
		current_scene.queue_free()
