extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(music_player)
	music_player.stream = preload("res://Assets/background music.wav")  # adjust path/filename to your actual file
	music_player.play()
