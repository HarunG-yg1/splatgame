class_name jumpin extends state_class
@onready var idle_state =  $"../idle"
@onready var move_state = $"../move"
@onready var dash_state =  $"../dash"
@onready var block_state = $"../block"

func Enter():
	guy1.jump_vel = 0
	#print("jump")
	guy1.velocity *= 0.75
	pass
func Process(_delta):

	guy1.move(guy1.direction,0.75)
	
	if !guy1.jumping:
		return move_state
	elif guy1.run and !guy1.finish_run and guy1.jump_vel >=0:
		return dash_state
	elif guy1.blocking and  guy1.jump_vel >=0 and guy1.stun < 0.75:
		return block_state

func Exit():
	pass
