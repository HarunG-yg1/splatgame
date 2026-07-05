class_name Enemy_State_Chase extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var idle_state =$"../idle"

func init() -> void:
	pass

#what happens when player enters state
func Enter() ->void:
	#enemy.cardinal_direction = Vector2.ZERO
	timer.start(10)
	
	await get_tree().create_timer(1).timeout

	enemy.UpdateAnimation("walk")
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized()*Vector2(abs(enemy.direction.y),abs(enemy.direction.x)) + enemy.direction).normalized() * enemy.SPEED*(enemy.global_position - enemy.player.global_position).length()*0.016) , 0.1)
	
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position).length() > 80:
		enemy.direction = enemy.chase_dir

		
		
	
	
	#print(enemy.direction)
	if enemy.SetDirection():
		enemy.AnimDirect()
		enemy.UpdateAnimation("walk")
	
	#enemy.AnimDirect()
	if timer.get_time_left() <= 0.1:
		enemy.player = null
		enemy.chase = false
		return idle_state
	return null
