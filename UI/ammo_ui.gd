extends Control

@onready var bullet_container: HBoxContainer = $BulletDisplay
var bullet_icons: Array[TextureRect] = []
var gun: Node = null

func _ready() -> void:
	for child in bullet_container.get_children():
		bullet_icons.append(child)

	await get_tree().process_frame   
	var player = SceneManager.player
	if player == null:
		push_warning("scenemanager is null we are cooked")
		return

	gun = player.get_node("Gun")
	if gun == null:
		push_warning("WHERE IS GUN UNDER PLAYER")
		return

	_update_icons(gun.current_ammo, gun.max_ammo)
	gun.ammo_changed.connect(_update_icons)

func _update_icons(current: int, max: int) -> void:
	for i in range(bullet_icons.size()):
		if i < current:
			bullet_icons[i].modulate = Color.WHITE
		else:
			bullet_icons[i].modulate = Color.BLACK
