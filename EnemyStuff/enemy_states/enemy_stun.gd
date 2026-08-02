class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"
var init_stun_time : float
var changed_dir := false
func init() -> void:
	pass
func Enter() ->void:
	changed_dir = false
	init_stun_time = enemy.stun
	print("stun" , enemy)
	#enemy.set_collision_mask_value(2,false)
	print(enemy.stun,"stunn")
	timer.start(enemy.stun)
	enemy.stun = 0
	enemy.UpdateAnimation("idle")

	pass
	
#what happens when player enters state
func Exit() ->void:
	#enemy.set_collision_mask_value(2,true)
	
	enemy.enemy_fov.get_child(0).disabled = false
	if init_stun_time > 0.5:
		enemy.stun = -1
	#enemy.velocity *= 0.1
		enemy.in_attk_type = enemy.in_attk_type_copy
		enemy.in_attk_index = 99
		enemy.animfx.stop()
		enemy.animfx.modulate = Color.WHITE
		enemy.animfx.play("default")
	
	
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	if  enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision() != Player and !changed_dir:
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
		changed_dir = true
	if timer.get_time_left() < init_stun_time - 0.11 :
		if (enemy.velocity.length()) > 2:

			enemy.velocity = ( enemy.velocity)*0.98
		else:
			enemy.velocity = Vector2(0,0)

	if timer.get_time_left() < 0.05 and enemy.stun <= 0:
		if enemy.velocity.length() < 160:
			return idle_state
	elif timer.get_time_left() < 0.05 and enemy.stun > 0.02:
		Enter()
		
	return null
