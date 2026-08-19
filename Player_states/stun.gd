class_name stun extends state_class
var init_stun_time : float
var changed_dir := false
@onready var idle_state : state_class = $"../idle"
@onready var timer : Timer = $"../../Timer"

func Enter() ->void:
	changed_dir = false
	init_stun_time = guy1.stun_time

	timer.start(guy1.stun_time)
	guy1.sprite.play("idle")
	guy1.stun_time = 0


	pass
	
#what happens when player enters state
func Exit() ->void:
	#guy1.set_collision_mask_value(2,true)
	
	guy1.i_time = 0.2
	
#what happens during process in state
func Process(_delta:float)->state_class:

	if  guy1.get_last_slide_collision() != null and guy1.get_last_slide_collision() != Enemy and !changed_dir:
		var temp_prior_vel = (guy1.velocity.normalized() + 2*guy1.get_last_slide_collision().get_normal()).normalized() * 400
		if( guy1.get_last_slide_collision().get_normal().x >0) :
			temp_prior_vel.x = abs(temp_prior_vel.x)
		else:
			temp_prior_vel.x = -abs(temp_prior_vel.x)
		if(guy1.get_last_slide_collision().get_normal().y >0) :
			temp_prior_vel.y = abs(temp_prior_vel.y)
		else:
			temp_prior_vel.y = -abs(temp_prior_vel.y)
		guy1.velocity = temp_prior_vel
		changed_dir = true

	if (guy1.velocity.length()) > 2:

		guy1.velocity = ( guy1.velocity)*0.95
		
	else:
		
		guy1.velocity = Vector2(0,0)

	if timer.get_time_left() <= 0.08 and guy1.stun_time <= 0:
		if guy1.velocity.length() < 160:
			return idle_state
	elif timer.get_time_left() <= 0.08 and guy1.stun_time > 0.02:
		Enter()
		
	return null
