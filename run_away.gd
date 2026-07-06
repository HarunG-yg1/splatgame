class_name Enemy_State_RunAway extends Enemy_State

##ref to what this state belongs to

@onready var timer = $"../../StateTimer"
@onready var attk_timer = $"../../AttkCDTimer"
@onready var idle_state =$"../idle"
@onready var attack_state = $"../attack"
var juke : bool =  false

func init() -> void:
	pass

#what happens when player enters state
func Enter() ->void:
	enemy.set_collision_mask_value(2,false)
	enemy.direction = -enemy.chase_dir
	enemy.random_pt =  Vector2(randi_range(-25,25),randi_range(-25,25))
	timer.start(10)
	
	await get_tree().create_timer(1).timeout


	pass
	
#what happens when player enters state
func Exit() ->void:
	enemy.set_collision_mask_value(2,true)
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	if juke:

		
		enemy.velocity =  lerp(enemy.velocity,((enemy.direction).normalized()) * enemy.SPEED * 1.8 , 0.1)
	if !juke and enemy.player!= null and  enemy.player!= null and( enemy.direction - enemy.player.velocity.normalized()).length() < 1.4 and enemy.player.velocity.length() > 0 and (enemy.global_position - enemy.player.global_position ).length() <80:
		enemy.direction = enemy.chase_dir
		
		juke = true
	if juke and  enemy.player!= null and (enemy.global_position - enemy.player.global_position ).length() >90 :
		
		juke = false
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/4).normalized()) * enemy.SPEED *1.5 , 0.1)

	#if enemy.player!= null and (enemy.global_position - enemy.player.global_position ).length() > 100:
		
	if (enemy.global_position - enemy.player.global_position).length() > 160 and attk_timer.get_time_left()<=0.1:
		attk_timer.start(3)
		return attack_state
	

	
	#enemy.AnimDirect()
	if timer.get_time_left() <= 0.1:
		enemy.player = null
		enemy.chase = false
		return idle_state
	return null
