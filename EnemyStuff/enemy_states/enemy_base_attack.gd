class_name enemy_attack extends Enemy_State 
func init() -> void:
	pass
var random_pt : Vector2
var amount_hits : int

var was_out_of_range := true
var time_for_hit : Array[float]
@onready var runAway_state = $"../runAway"
@onready var chase_state = $"../chase"
@onready var idle_state =$"../idle"
@onready var stun_state =$"../stun"

var init_time : float
#what happens when player enters state
func Enter() ->void:
	print("melee" , enemy)

	enemy.random_pt =  Vector2(randi_range(-15,15),randi_range(-15,15))
	time_for_hit = enemy.out_attk_time
	
	amount_hits= randi_range(3,8)
	time_for_hit[amount_hits-1] += 0.5
	init_time = time_for_hit[amount_hits-1]
	was_out_of_range = true
	pass
	
#what happens when player enters state
func Exit() ->void:
	
	pass
	
#what happens during process in state

func Process(_delta:float)->Enemy_State:
	
	if enemy.stun > 0:
		print("penis")
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return stun_state 
	
	if enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position ).length() > 50:
		if !was_out_of_range:
			time_for_hit[amount_hits-1] += 0.25
		was_out_of_range = true
		return move()
	elif  enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position).length() <50:
		was_out_of_range =  false
		if (enemy.hitter.global_position - enemy.player.global_position).length() > 40:
			enemy.velocity =  enemy.chase_dir * enemy.player.MAX_SPEED * 0.9
		
		enemy.velocity = lerp(enemy.velocity,Vector2.ZERO,0.1)
		return attack_rythm(_delta)
	

	return null

func attack_now():
	if enemy.player != null:
		
		enemy.hitter.disabled = false
		await get_tree().create_timer(0.2).timeout
		enemy.animsprite.play("false")
	pass

func move():
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 120:
		return runAway_state
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 80:

		enemy.direction = enemy.chase_dir
	if enemy.player!= null and ((enemy.global_position - enemy.player.global_position + random_pt).normalized() - (enemy.direction)).length() < 0.7  and (enemy.hitter.global_position - enemy.player.global_position).length() > 60:
	#	print("chase bro son")
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/4).normalized()) * enemy.SPEED * 2 , 0.1)
	elif enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position + random_pt).length() > 60:
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction*1.05).normalized()) * enemy.SPEED *2 , 0.1)
	elif enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position + random_pt).length() <50:
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.05).normalized()) * enemy.SPEED * 2 , 0.1)


func attack_rythm(_delta):
	time_for_hit[amount_hits-1] -= _delta
	if (time_for_hit[amount_hits-1] < init_time * 0.75 and time_for_hit[amount_hits-1] > init_time * 0.74)|| init_time < 0.6 and (time_for_hit[amount_hits-1] < init_time and time_for_hit[amount_hits-1] > init_time * 0.9):
		

#		enemy.animfx.rotation = enemy.hitter2.rotation

		enemy.animfx.scale.y =1
		enemy.animfx.scale.x =1

		if init_time < 1:
			enemy.animfx.play("shine2")
		else:
			
			enemy.animfx.play("shineBlue")



	elif (time_for_hit[amount_hits-1] <= 0.25 and time_for_hit[amount_hits-1] > 0.249):
		#enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(player.global_position),2)

		enemy.animfx.play("shine1")

	elif time_for_hit[amount_hits-1] <= 0:
		#enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(player.global_position),2)
		enemy.animfx.scale.y =1
		enemy.animfx.play("shine1")

		enemy.animsprite.play("hit")
		
		attack_now()
		amount_hits -= 1
		#time_for_hit[amount_hits-1] += 0.2
		init_time = time_for_hit[amount_hits-1]

	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return idle_state

	#	func attack_rythm(_delta):
	#	time_for_hit[amount_hits-1] -= _delta
	#	if time_for_hit[amount_hits-1] <= 0.5:
	#		enemy.animfx.scale.x = 1
	#		enemy.animfx.scale.y = 1
	#		enemy.animfx.play("shineMelee")
	#	if time_for_hit[amount_hits-1] <= 0:
	#		attack_now()
#
		#	enemy.animsprite.play("hitMelee")
	#		amount_hits -= 1
	#	if amount_hits <=0:
	#		print("penis")
	#		enemy.player = null
	#		enemy.chase = false
	#		enemy.enemy_fov.get_child(0).disabled = true
	#		enemy.enemy_fov.get_child(1).disabled = true
	#		return idle_state
	
