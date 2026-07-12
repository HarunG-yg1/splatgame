class_name arrow extends Node2D
var enemy_Owner : Enemy
enum enemy_attack_types  {RED,BLUE,GREEN}
var enemy_attk_type : enemy_attack_types
var alive : bool = false
var hit : bool = false
var melee : bool
@onready var animSprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func init(enemy : Enemy, attk_color : int, hit_time : float, is_melee : bool = true):
#	position.y = 0
	if  hit_time > 0.05:
		enemy_Owner = enemy
		enemy_attk_type = attk_color

		match enemy_attk_type:
			enemy_attack_types.RED:
				animSprite.play("red")
			enemy_attack_types.BLUE:
				animSprite.play("blue")
			enemy_attack_types.GREEN:
				animSprite.play("green")
		visible  = true
		alive = true
		hit = false
		melee = is_melee
		position.y = -(get_viewport_rect().size.y)*hit_time  + 40
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		visible  = false
		alive = false
		hit = false
		process_mode = Node.PROCESS_MODE_DISABLED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += get_viewport_rect().size.y * delta
	pass
	




	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
	alive = false
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.
