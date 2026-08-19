class_name moving extends state_class
@onready var idle_state =  $"../idle"
@onready var block_state =  $"../block"
@onready var crouch_state = $"../crouching"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
@onready var attack_state = $"../attack"
@onready var shoot_state = $"../shoot"
@onready var stun_state = $"../stun"
var had_prior_vel : Vector2
func Enter():
	guy1.sprite.play("move")
	pass
func Process(_delta):
	
	if guy1.velocity.length() <= 250 and guy1.sprite.animation == "move":
		guy1.sprite.play("idle")
	elif guy1.velocity.length() > 250 and guy1.sprite.animation != "move":
		guy1.sprite.play("move")
	guy1.move(guy1.direction,1,0.05)
	if guy1.direction.length() == 0.0 and guy1.g_timer.get_time_left() <= 0.02:
		return idle_state
	elif guy1.blocking and guy1.stun_time < 0.75:
		return block_state
	elif guy1.crouch:
		#print("fuck you")
		return crouch_state
	elif guy1.dashing:
		#print("bark")
		return dash_state 
	elif guy1.is_attack :
		return attack_state
	elif guy1.is_shoot :
		return shoot_state
	elif guy1.jumping:
		return jump_state
	elif guy1.stun_time > 0:
		return stun_state
	

func Exit():
	pass
