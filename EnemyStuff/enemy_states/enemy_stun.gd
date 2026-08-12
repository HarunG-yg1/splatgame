class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"
var init_stun_time : float
var delay : float
var away_dir : Vector2
var away_pwr : float = 0.75
var index : int = 0
func init() -> void:
	pass
func Enter() ->void:
	
	if enemy.player != null:
		away_dir =  (randi_range(-1,1) * enemy.secondary_vel.normalized()/2 + enemy.player.velocity.normalized()).normalized() *600 
		if enemy.player.velocity.length() == 0:
			away_dir =   ( randi_range(-1,1)*enemy.secondary_vel.normalized()/2 + enemy.player.last_dir.normalized()).normalized() *600 
	init_stun_time = enemy.stun_time
	
	enemy.velocity *= 0
	
	timer.start(enemy.stun_time)
	
	enemy.stun_time = 0
	
	enemy.UpdateAnimation("idle")
	index += 1
	pass
	
#what happens when player enters state
func Exit() ->void:
	
	index = 0
	enemy.stun_time = 0
	
	if init_stun_time >= 0.75:

	#enemy.velocity *= 0.1
		enemy.stun_time = -1
		enemy.in_attk_type = enemy.in_attk_type_copy
		enemy.in_attk_index = 99
		enemy.animfx.stop()
		enemy.animfx.modulate = Color.WHITE
		enemy.animfx.play("default")
	
	
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:

	if  enemy.get_last_slide_collision() != null and enemy.get_last_slide_collision() != Player:
		var temp_prior_vel = (enemy.velocity.normalized() + 2*enemy.get_last_slide_collision().get_normal()).normalized() * 400
		if( enemy.get_last_slide_collision().get_normal().x >0) :
			temp_prior_vel.x = abs(temp_prior_vel.x)
		else:
			temp_prior_vel.x = -abs(temp_prior_vel.x)
		if(enemy.get_last_slide_collision().get_normal().y >0) :
			temp_prior_vel.y = abs(temp_prior_vel.y)
		else:
			temp_prior_vel.y = -abs(temp_prior_vel.y)
		enemy.velocity = temp_prior_vel.normalized() * 400

	
	if timer.get_time_left() <= init_stun_time - delay and  enemy.velocity.length() <= 1:
		enemy.velocity = ( away_dir) 
		#print("stun wnot")

	elif timer.get_time_left() < init_stun_time - delay and enemy.velocity.length() > 1:
		
		
		enemy.velocity  *=  away_pwr

		
#	print(timer.get_time_left(),"timee")

	if timer.get_time_left() <= 0.05 and (enemy.stun_time <= 0 || init_stun_time >= 0.75):
		if enemy.velocity.length() < 160:
			return idle_state
	elif timer.get_time_left() <= 0.05 and enemy.stun_time >= 0.25:
		
		Enter()

	return null
