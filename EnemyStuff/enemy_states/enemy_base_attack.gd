class_name enemy_attack extends Enemy_State 
func init() -> void:
	pass
var random_pt : Vector2
var amount_hits : int
var time_on_player : float = 0
var was_out_of_range := true
var time_for_hit : Array[int_float_pair] = [int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0),int_float_pair.new(0,0)]
@onready var runAway_state = $"../runAway"
@onready var chase_state = $"../chase"
@onready var idle_state =$"../idle"
@onready var stun_state =$"../stun"
@onready var gen_timer = $"../../general_timer"
var init_time : float
#what happens when player enters state
func Enter() ->void:
	enemy.stun = 0
	print("attack" , enemy)
	time_on_player = 0
	gen_timer.start(7)
	var acc : float = 0

	amount_hits= randi_range(3,8)
	for i : int in range(amount_hits-1):
		
		time_for_hit[i].time = enemy.out_attk_time[amount_hits - i - 1]
		time_for_hit[i].number = enemy.out_attk_color[amount_hits - i - 1]
		
		#acc = time_for_hit[i].time
	print(enemy.out_attk_time.size())
	time_for_hit[amount_hits-1].time += 0.5
	init_time = time_for_hit[amount_hits-1].time
	enemy.random_pt =  Vector2(randi_range(-15,15),randi_range(-15,15))
	

	was_out_of_range = true

	
#what happens when player enters state
func Exit() ->void:
	#if enemy.player != null:
	#	enemy.player.refund_dodge()

	RythmLoader.interrupt(enemy)
#	pass
	
#what happens during process in state

func Process(_delta:float)->Enemy_State:
	
	if enemy.stun > 0 and gen_timer.get_time_left() <= 4 :
	#	RythmLoader.interrupt(enemy)
		print("penis")
		enemy.enemy_fov.get_child(0).disabled = true
	#	enemy.enemy_fov.get_child(1).disabled = true
		if enemy.player != null:
			enemy.player.refund_dodge()
			enemy.player = null
		enemy.chase = false
		return stun_state 
	else:
		enemy.stun = 0
	if (enemy.player!= null and time_on_player < 0.25) || ( enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160):
		if !was_out_of_range:
			
			was_out_of_range = true
			time_for_hit[amount_hits-1].time += 0.5
			RythmLoader.interrupt(enemy)
		return move(_delta)
		
	
	elif  enemy.player!= null and time_on_player > 0.25 :
		if was_out_of_range:
			
			
			RythmLoader.addTo_hitline(time_for_hit,enemy)
			
			was_out_of_range =  false

		
	#	
		return attack_rythm(_delta)
	elif enemy.player == null:
		enemy.enemy_fov.get_child(0).disabled = true

		enemy.player = null
		enemy.chase = false
		return idle_state

	return null

func attack_now():
	if enemy.player != null:
		
		enemy.hitter.disabled = false

	#	enemy.player.missed = false

func move(delta : float ,modifier : float = 1):
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160:
		
		return runAway_state
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 80:
		time_on_player -= delta/5
		enemy.direction = enemy.chase_dir
	if enemy.player!= null and ((enemy.global_position - enemy.player.global_position + random_pt).normalized() - (enemy.direction)).length() < 0.7  and (enemy.global_position - enemy.player.global_position).length() > 60:
		
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.2).normalized()) * enemy.SPEED * modifier , 1) 
	elif enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 60:
		time_on_player += delta
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction*1.05).normalized()) * enemy.SPEED * modifier , 1)
	else:
		if  enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() < 60:
			time_on_player += delta
		enemy.velocity =  lerp(enemy.velocity, Vector2.ZERO,0.2)
		


func attack_rythm(_delta):
	print( "time time",amount_hits-1," ",time_for_hit[amount_hits-1].time , " ",time_for_hit[amount_hits-1].number )
	time_for_hit[amount_hits-1].time  -= _delta
	if time_for_hit[amount_hits-1].time > init_time * 0.4:
		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() >50:
			enemy.velocity =  enemy.chase_dir *  enemy.player.MAX_SPEED 
		else:
			move(_delta)
			

	if time_for_hit[amount_hits-1].time <= init_time * 0.3 and time_for_hit[amount_hits-1].time > init_time * 0.29:
		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() >50:
			enemy.velocity =  enemy.chase_dir *  enemy.player.MAX_SPEED * 1.5
		else:
			move(_delta)
		
	elif time_for_hit[amount_hits-1].time <= 0:
	
		enemy.animfx.scale.y =1
		print("gertfoeld")
		#enemy.animfx.stop()
		enemy.animfx.play("shine1")

	#	enemy.animsprite.play("hit")
		enemy.velocity =  lerp(enemy.velocity, Vector2.ZERO,0.2)
		#enemy.velocity =  enemy.chase_dir * enemy.player.MAX_SPEED * 1.6
		attack_now()
	#	move(_delta, 1.5)
		amount_hits -= 1

		init_time = time_for_hit[amount_hits-1].time

	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true
	#	enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return idle_state
