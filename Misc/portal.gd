extends Area2D # portal

@export var file_path : String
@export var tp_coords : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SceneManager.next_scene != "":
		file_path = SceneManager.next_scene
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass






func _on_body_entered(body:Player) -> void:
	
	
	SceneManager.tp_coords =  tp_coords
	SceneManager.call_deferred("change_scene",body,file_path)
	Statloader.set_statsToLoader(body)
	
