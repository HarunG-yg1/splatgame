class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"

var changed_dir := false
func init() -> void:
	pass
func Enter() ->void:
	changed_dir = false
	
	print("stun" , enemy)
	enemy.set_collision_mask_value(2,false)
	print(enemy.stun,"stunn")
	timer.start(enemy.stun)
	enemy.stun = 0
	enemy.UpdateAnimation("idle")
	if enemy.in_attk_index <= 7:
		if enemy.in_attk_type[enemy.in_attk_index] == 0:
			enemy.animfx.play("shineRed")
		elif enemy.in_attk_type[enemy.in_attk_index] == 1:
			enemy.animfx.play("shineBlue")
		elif enemy.in_attk_type[enemy.in_attk_index] == 2:
			enemy.animfx.play("shineGreen")

	pass
	
#what happens when player enters state
func Exit() ->void:
	enemy.set_collision_mask_value(2,true)
	enemy.animfx.stop()
	enemy.stun = -1
	
	
	enemy.enemy_fov.get_child(0).disabled = false
	enemy.in_attk_index = 99
	enemy.animfx.play("default")
	
	
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	#print("LEMME OUT")
	if enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision() != Player and !changed_dir:
		var temp_prior_vel = (enemy.velocity.normalized() + 2*enemy.get_last_slide_collision().get_normal()).normalized() * 400
		if( enemy.get_last_slide_collision().get_normal().x >0) :
			temp_prior_vel.x = abs(temp_prior_vel.x)
		else:
			temp_prior_vel.x = -abs(temp_prior_vel.x)
		if(enemy.get_last_slide_collision().get_normal().y >0) :
			temp_prior_vel.y = abs(temp_prior_vel.y)
		else:
			temp_prior_vel.y = -abs(temp_prior_vel.y)
		enemy.velocity = temp_prior_vel
	if (enemy.velocity.length()) > 1 :

		enemy.velocity -= -enemy.secondary_vel.normalized() + enemy.velocity/45  
	elif abs(enemy.velocity.length()) < 1:
		enemy.velocity = Vector2(0,0)
	if timer.get_time_left() < 0.05 and enemy.stun <= 0:
		
		return idle_state
	elif timer.get_time_left() < 0.05 and enemy.stun > 0.1:
		Enter()
		
	return null
