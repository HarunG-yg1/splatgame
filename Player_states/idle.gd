class_name idle extends state_class
@onready var crouch_state = $"../crouching"
@onready var block_state =  $"../block"
@onready var move_state = $"../move"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
@onready var attack_state = $"../attack"
@onready var shoot_state = $"../shoot"
@onready var stun_state = $"../stun"

func Enter():
	#print("idle")
	pass
func Process(_delta):
	if guy1.blocking  and guy1.stun_time < 0.75:
		return block_state
	if guy1.crouch:
		return crouch_state
	if (guy1.velocity.length()) > 1 and !guy1.jumping:
		if statemachine.old_state is attack:
			guy1.velocity -= guy1.velocity/45 
		else:
			guy1.velocity -= guy1.velocity/15
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
	if guy1.direction.length() > 0.0:
		return move_state
	elif guy1.jumping:
		return jump_state
	elif guy1.dashing:
		guy1.velocity -= guy1.last_dir * 300
		print(guy1.last_dir)
		return dash_state 
	elif guy1.is_shoot :
		return shoot_state
	elif guy1.is_attack:
		return attack_state
	elif guy1.stun_time > 0:
		return stun_state

func Exit():
	pass
