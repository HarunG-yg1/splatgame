class_name attack extends state_class

var prior_attack_box_size : float
var prior_attack_box_displace : float
@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"

var timer :=0.4
var speed_mod : float= 1
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x

	print("Attack")
#	count += 1
	guy1.curr_attk = 1
	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineBlue")
	timer = 0.5
	
func Process(_delta):
	
	#print(guy1.out_attk_time)
	
	
	timer -= _delta
	if timer > 0:
		attack_movement(_delta)

	if hit_boxOn():
		guy1.attack_shape.disabled = false 

	elif timer <= 0:
		
		if statemachine.old_state is not dash and statemachine.old_state is not jumpin and statemachine.old_state is not dive and statemachine.old_state is not block  and statemachine.old_state is not attack:
			
			return statemachine.old_state
		#return idle_state
		else:
			return idle_state 
		
	

func hit_boxOn()->bool:
	return timer <= 0.25 and  timer > 0.24
	
func Exit():
	guy1.attack_shape.position.x = prior_attack_box_displace 
	guy1.attack_shape.shape.size.x = prior_attack_box_size
	guy1.attack_shape.disabled = true
	guy1.is_attack = false

func attack_movement(delta):
	if guy1.direction.length() > 0.0:
		guy1.move(guy1.direction,speed_mod)
	elif (guy1.velocity.length()) > 1 :

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
	#return guy1.direction
