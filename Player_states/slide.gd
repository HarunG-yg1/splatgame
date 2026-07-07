class_name slide extends crouch_idle

@onready var crouch_state = $".."
@onready var dive_state = $dive

var prior_rotation : float
var prior_vel_dir : Vector2



func Enter():
	if guy1.last_puddle != null:
		guy1.check_puddle(guy1.last_puddle.puddle_val,guy1.last_puddle)
	
	prior_rotation = guy1.sprite.rotation
	guy1.velocity*= 1.05 +abs( guy1.jump_vel/160)
	guy1.jump_vel = 0
	if guy1.velocity.length() > 440:
		guy1.i_time = 0.25
	prior_vel_dir = guy1.velocity
	print(prior_vel_dir)

	pass
func Process(_delta):
	guy1.sprite.look_at(guy1.velocity)
#	print("sliding")
	prior_vel_dir *= 0.98
	guy1.velocity = prior_vel_dir + guy1.direction*150
	if (guy1.velocity.normalized()  -prior_vel_dir.normalized()).length() > 1.4:
	#	print("ight stop")
		guy1.velocity= guy1.velocity.normalized() *50
		
		return crouch_state
	

	elif !guy1.crouch:
		return crouch_state.idle_state
	elif guy1.run and !guy1.finish_run:
		guy1.crouch=false
		return crouch_state.dash_state
	elif guy1.dive_in:
		return dive_state
	if guy1.jumping:
		guy1.crouch=false
		return crouch_state.jump_state
	elif guy1.signal_attk:
		return crouch_state.attack_state

func Exit():
	
	
	guy1.sprite.rotation=prior_rotation
	pass
