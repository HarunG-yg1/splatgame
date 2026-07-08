extends Control

@onready var restart_button: Button = $RestartButton

func _ready() -> void:
	restart_button.visible = false

	await get_tree().process_frame
	var player = Statloader.player
	if player == null:
		push_warning("DeathScreen: Statloader.player is null")
		return

	player.died.connect(_on_player_died)
	restart_button.pressed.connect(_on_restart_pressed)

func _on_player_died() -> void:
	restart_button.visible = true

func _on_restart_pressed() -> void:
	Statloader.reset()
	get_tree().reload_current_scene()
