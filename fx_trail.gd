extends Node

var player : Player
var index : int = 0
var sprites : Array[Sprite2D]
var move_dir : Array[Vector2] = [Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO,Vector2.ZERO]
@onready var timer : Timer = $Timer
func _ready() -> void:
	for i : Object in get_children():
		if i is Sprite2D:
			sprites.append(i)

func init( plyr:Player , emit : bool = false):
	
	plyr.start_trail.connect(start_trail)
	if emit:
		plyr.start_trail.emit(plyr)

func get_frame(sprite : Sprite2D):
	sprite.modulate = player.curr_attk
	sprite.scale.x = 1.6
	sprite.scale.y = 1
	sprite.modulate.a = 0.2
	sprite.global_position = player.global_position
	sprite.rotation = player.attack_box.rotation
	var frameIndex: int = player.sprite.get_frame()
	var animationName: String = player.sprite.animation
	var spriteFrames: SpriteFrames = player.sprite.get_sprite_frames()
	var currentTexture: Texture2D = spriteFrames.get_frame_texture(animationName, frameIndex)
	
	sprite.texture = currentTexture
	
func start_trail(plyr :Player):
	player = plyr
	index = 0
	process_mode = Node.PROCESS_MODE_INHERIT

	timer.start(0.05)
	
		
		

func _on_timer_timeout() -> void:

	if index < sprites.size():
		get_frame(sprites[index])
		move_dir[index] = player.velocity.normalized()
		index += 1
		timer.start(0.05)



func _process(delta: float) -> void:
	if check_all_alpha0(delta):
		process_mode = Node.PROCESS_MODE_DISABLED
		player = null
		print("ntuhh")

func check_all_alpha0(delta) -> bool:
	var is_0 : bool = true
	if index < sprites.size():
		return false
	for i in range(sprites.size()):
		if sprites[i].modulate.a > 0:
			sprites[i].scale.x += delta/4
			sprites[i].modulate.a -= delta/3
			if sprites[i].modulate.a <= 0:
				sprites[i].modulate.a = 0
			sprites[i].position += move_dir[i]/10
			is_0 = false
	return is_0
