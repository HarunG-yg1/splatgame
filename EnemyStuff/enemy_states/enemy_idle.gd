class_name Enemy_State_Idle extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var attack_state  = $"../attack"
@onready var roam =$"../roam"
@onready var chasing =$"../chase"
@onready var runaway =$"../runAway"
var range_chase := false
#what happens when player enters state
func init() -> void:
	pass
func Enter() ->void:
	range_chase = false
	print("idle", enemy)
	timer.start(enemy.choose_randomly([0.5,1.5,2,1]))
	enemy.UpdateAnimation("idle")
	enemy.enemy_fov.get_child(0).disabled = false
	enemy.enemy_fov.get_child(1).disabled = false

	pass
	
#what happens when player enters state
func Exit() ->void:
	enemy.enemy_fov.get_child(0).disabled = false
	enemy.enemy_fov.get_child(1).disabled = false
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	if enemy is ranged:
		enemy.hitter2.rotation += deg_to_rad(0.5)
		if enemy.hitter2.get_collider() != null and  enemy.hitter2.get_collider() is Player and (enemy.global_position - enemy.hitter2.get_collider().global_position ).length()>180:
			enemy.player =  enemy.hitter2.get_collider()
			enemy.chase = true
			range_chase = true
			
	enemy.velocity = lerp (enemy.velocity,Vector2.ZERO,0.1)
	if enemy.chase and chasing != null:
		if runaway != null and range_chase:
			return runaway
		return chasing
		
	elif  enemy.chase and runaway != null:
		
		return runaway
	if timer.get_time_left() <= 0.1:
		
		return roam
	
	return null
