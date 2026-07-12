class_name slide extends crouch_idle

@onready var crouch_state = $".."
@onready var dive_state = $dive

var prior_rotation : float
var prior_vel_dir : Vector2
var timer : float = 0.4


func Enter():
	timer = 0.4
	if RythmLoader.find_attkType(2) :
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2
	guy1.set_collision_mask_value(8,false)
	if guy1.last_puddle != null:
		guy1.check_puddle(guy1.last_puddle.puddle_val,guy1.last_puddle)
	
	prior_rotation = guy1.sprite.rotation
	guy1.velocity = crouch_state.had_prior_vel * 1.3
	guy1.jump_vel = 0

	prior_vel_dir = crouch_state.had_prior_vel  * 1.3
	print(prior_vel_dir)

	pass
func Process(_delta):
	timer -= _delta
	if RythmLoader.find_attkType(2) and timer > 0:
		RythmLoader.setHit_attkType(2)
		guy1.i_time = 0.2
	guy1.sprite.look_at(guy1.velocity)
#	print("sliding")
	prior_vel_dir *= 0.98
	guy1.velocity = prior_vel_dir + guy1.direction*150
	if (guy1.velocity.normalized()  -prior_vel_dir.normalized()).length() > 1.4:
	#	print("ight stop")
		guy1.velocity= guy1.velocity.normalized() *50
		
		return crouch_state
	

	elif !guy1.crouch:
		guy1.set_collision_mask_value(8,true)
		return crouch_state.idle_state
	elif guy1.dashing:
		guy1.set_collision_mask_value(8,true)
		guy1.crouch=false
		return crouch_state.dash_state
	elif guy1.dive_in:
		
		return dive_state
	if guy1.jumping:
		guy1.set_collision_mask_value(8,true)
		guy1.crouch=false
		return crouch_state.jump_state
	if guy1.blocking:
		guy1.set_collision_mask_value(8,true)
		return crouch_state.block_state
	elif guy1.is_attack:
		return crouch_state.slide_attack_state
	elif guy1.is_shoot:
		return crouch_state.shoot_state

func Exit():
	
	
	guy1.sprite.rotation=prior_rotation
	pass
