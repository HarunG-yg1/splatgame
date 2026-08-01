class_name attack extends state_class


@onready var idle_state = $"../idle"
@onready var move_state = $"../move"
@onready var jump_state = $"../jump"
@onready var dash_state = $"../dash"
var target : Enemy
var timer :=0.4
var speed_mod : float= 1
func _init() -> void:
	for i in get_children():
		i.guy1 = self.guy1
		i.statemachine = self.statemachine

func Enter():
	target = guy1.curr_out_attked
	guy1.curr_out_attked = null


	print("Attack")
#	count += 1
	guy1.curr_attk = RythmLoader.add_color(Color.WHITE,guy1.curr_attk)
	guy1.animfx.modulate = guy1.curr_attk
	guy1.animfx.play("shine1")
	timer = 0.4



func Process(_delta):
	
	#print(guy1.out_attk_time)
	
	
	timer -= _delta
	if timer > 0:
		attack_movement(_delta)

	if hit_boxOn():
		guy1.attack_shape.disabled = false 
	if hit_boxOff():
		guy1.attack_shape.disabled = true
	elif timer <= 0:
		
		if statemachine.old_state is not dash and statemachine.old_state is not jumpin and statemachine.old_state is not dive and statemachine.old_state is not block  and statemachine.old_state is not attack:
			
			return statemachine.old_state
		#return idle_state
		else:
			return idle_state 
		
	

func hit_boxOn()->bool:
	return timer <= 0.25 and  timer > 0.24
	
func hit_boxOff()->bool:
	return timer <= 0.01 and  timer > 0.02
func Exit():
	

	guy1.attack_shape.disabled = true
	guy1.is_attack = false
	guy1.set_collision_layer_value(2,true)
func attack_movement(delta):
	if hit_boxOn():
		guy1.sprite.play("BasicATK")
	if guy1.direction.length() > 0.0:
		guy1.move(guy1.direction,speed_mod)
	elif (guy1.velocity.length()) > 1 :

		guy1.velocity -= guy1.velocity/15  
		if abs(guy1.velocity.length()) < 1:
			guy1.velocity = Vector2(0,0)
	#return guy1.direction
