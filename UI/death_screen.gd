extends Control

@onready var restart_button: Button = $RestartButton
@export var player_path: NodePath

func _ready() -> void:
	restart_button.visible = false
	var player = get_node(player_path)
	player.died.connect(_on_player_died)
	restart_button.pressed.connect(_on_restart_pressed)

func _on_player_died() -> void:
	restart_button.visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_restart_button_pressed() -> void:
	Statloader.reset()
	pass # Replace with function body.
