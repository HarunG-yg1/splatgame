class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"
var init_stun_time : float
var away_dir : Vector2
var changed_dir := false
var index : int = 0
func init() -> void:
	pass
func Enter() ->void:
	if enemy.player != null:
		away_dir = -(enemy.player.global_position - enemy.global_position).normalized() * 600
	changed_dir = false
	init_stun_time = enemy.stun
	print("stunnigga ", enemy.stun , enemy)
	enemy.velocity *= 0
	
	timer.start(enemy.stun)
	enemy.stun = 0

	enemy.UpdateAnimation("idle")
	index += 1
	pass
	
#what happens when player enters state
func Exit() ->void:
	index = 0
	enemy.stun = 0
	
	if init_stun_time > 0.5:

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
	
	if timer.get_time_left() <= init_stun_time - 0.1 and enemy.velocity.length() <= 0:
		enemy.velocity = ( away_dir) 
		print("stun wnot")

	elif timer.get_time_left() <= init_stun_time - 0.11 and enemy.velocity.length() > 1:
		
		
		enemy.velocity *= 0.75

	print(timer.get_time_left(),"timee")

	if timer.get_time_left() <= 0.05 and (enemy.stun <= 0 || init_stun_time > 1):
		if enemy.velocity.length() < 160:
			return idle_state
	elif timer.get_time_left() <= 0.05 and enemy.stun >= 0.05:
		
		Enter()

	return null
