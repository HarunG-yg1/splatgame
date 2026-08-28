class_name arrow extends Node2D
var enemy_Owner : Enemy
var hittime : float
var enemy_attk_type : Color
var alive : bool = false
var hit : bool = false
var melee : bool
@onready var animSprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func init(enemy : Enemy, attk_color : Color , hit_time : float, is_melee : bool = true):
#	position.y = 0
	if  hit_time > 0.05:
		hittime = hit_time
		enemy_Owner = enemy
		enemy_attk_type = attk_color
		modulate = attk_color
		animSprite.play("default")
		visible  = true
		alive = true
		hit = false
		melee = is_melee
		global_position = get_parent().global_position + ((enemy.global_position - enemy.player.global_position).normalized()) * 100 * (hit_time) **3
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		visible  = false
		alive = false
		hit = false
		process_mode = Node.PROCESS_MODE_DISABLED
# Called every f9rame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_Owner == null:
		visible  = false
		alive = false
		hit = false
		process_mode = Node.PROCESS_MODE_DISABLED
	hittime -= delta
	if hittime > 0:
		global_position  = get_parent().global_position +  (enemy_Owner.global_position - enemy_Owner.player.global_position).normalized()  * 100 * (hittime) *abs(hittime) 
	else:
		global_position  = get_parent().global_position +  (enemy_Owner.global_position - enemy_Owner.player.global_position).normalized()  * 300 * (hittime) 
	if hit and animSprite.animation != "hit":
		animSprite.play("hit")
	pass
	




	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
	alive = false
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.
