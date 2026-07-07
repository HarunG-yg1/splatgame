extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar
@export var player_path: NodePath

func _ready() -> void:
	var player = get_node(player_path)
	progress_bar.max_value = player.max_health
	progress_bar.value = player.current_health
	player.health_changed.connect(_on_health_changed)

func _on_health_changed(current: int, max: int) -> void:
	progress_bar.max_value = max
	progress_bar.value = current
