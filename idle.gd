class_name idle extends state_class
@onready var crouch_state = $"../crouching"
@onready var block_state =  $"../block"
@onready var move_state = $"../move"
@onready var dash_state =  $"../dash"
@onready var jump_state = $"../jump"
func Enter():
	#print("idle")
	pass
func Process(_delta):
	if guy1.blocking  and guy1.stun < 0.5:
		return block_state
	if guy1.crouch:
		return crouch_state
	if (guy1.velocity.length()) > 1 and !guy1.jumping:

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
	if guy1.direction.length() > 0.0:
		return move_state
	elif guy1.jumping:
		return jump_state

func Exit():
	pass
