class_name enemy_attack extends Enemy_State 
func init() -> void:
	pass
var random_pt : Vector2
var amount_hits : int
var time_on_player : float = 0
var was_out_of_range := true
var time_for_hit : Array[float] = [0,0,0,0,0,0,0,0]
var color_for_hit : Array[Color] = [Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE,Color.WHITE]
@onready var runAway_state = $"../runAway"
@onready var chase_state = $"../chase"
@onready var idle_state =$"../idle"
@onready var stun_state =$"../stun"
@onready var timer = $"../../StateTimer"
var init_time : float 
#what happens when player enters state
func Enter() ->void:


	print("attack" , enemy)
	time_on_player = 0
	
	

	amount_hits= randi_range(5,7)
	for i : int in range(amount_hits):
		
		time_for_hit[i] = enemy.out_attk_time[amount_hits - i]
		color_for_hit[i] = enemy.out_attk_color[amount_hits - i]
		
	#print(enemy.out_attk_time.size())
	#time_for_hit[amount_hits-1] += 0.25
	init_time = time_for_hit[amount_hits-1]
	enemy.random_pt =  Vector2(randi_range(-7,7),randi_range(-7,7))
	
	timer.start(3)
	was_out_of_range = true

	
#what happens when player enters state
func Exit() ->void:
	enemy.hitter.disabled = true
	RythmLoader.interrupt(enemy)


func Process(_delta:float)->Enemy_State:
	
	if enemy.stun > 0 and timer.get_time_left() < 0.1:
		print("stunned haha")
		enemy.enemy_fov.get_child(0).disabled = true
		timer.stop()
		if enemy.player != null:
			enemy.player.refund_dodge()
			#enemy.player = null
		enemy.chase = false
		return stun_state 
	else:
		enemy.stun = 0
	
	if (enemy.player!= null and time_on_player < 0.25) || ( enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160):
		if !was_out_of_range:
			enemy.hitter.disabled = true
			was_out_of_range = true
			if time_for_hit[amount_hits-1] < 0.5:
				time_for_hit[amount_hits-1]+= 0.25
			RythmLoader.interrupt(enemy)
			timer.start(2)
		return move(_delta)
		
	
	elif  enemy.player!= null and time_on_player >= 0.25 :
		if was_out_of_range:
			
			
			RythmLoader.addTo_hitline(time_for_hit,color_for_hit,enemy)
			
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
		
		if runAway_state != null:
		
			return runAway_state
		
		else:
		
			time_on_player -= delta
			enemy.direction = enemy.chase_dir
	
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 100:

		time_on_player -= delta
		enemy.direction = enemy.chase_dir
	
	if enemy.player!= null and ((enemy.secondary_vel).normalized() - (enemy.direction)).length() < 0.7  and (enemy.global_position - enemy.player.global_position).length() > 90:
		
		
		enemy.velocity =  lerp(enemy.velocity,(enemy.secondary_vel.normalized()) * enemy.SPEED * modifier , 0.6) 

	elif enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 90:
	
		time_on_player += delta
		enemy.velocity =  lerp(enemy.velocity,enemy.direction * enemy.SPEED * modifier , 0.6)

	else:
		if  enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() < 90:
		
			
			time_on_player += delta
			if (enemy.global_position - enemy.player.global_position + random_pt).length() <= 35:
				if ((enemy.secondary_vel).normalized() + (enemy.direction) ).length() < 0.7:
					enemy.velocity =  lerp(enemy.velocity,enemy.secondary_vel.normalized() * enemy.SPEED * 0.5 , 0.2)
				else:
					enemy.velocity =  lerp(enemy.velocity,-enemy.direction * enemy.SPEED * 0.5 , 0.2)
	
			elif (enemy.global_position - enemy.player.global_position + random_pt).length() < 70:
				
				enemy.velocity =  lerp(enemy.velocity,((Vector2(enemy.direction.y,enemy.direction.x)*1.05).normalized()) * enemy.SPEED  * 0.4 , 0.2)
			

func attack_rythm(_delta):
	
	time_for_hit[amount_hits-1]  -= _delta
	#print("yp",time_for_hit[amount_hits-1])
	if time_for_hit[amount_hits-1] > 0.2:
		if  time_for_hit[amount_hits-1] <= init_time - 0.2:
			enemy.hitter.disabled = true
		
		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() >60:
	
			enemy.velocity = lerp(enemy.velocity,enemy.chase_dir *  enemy.SPEED * 1.5 ,0.5) 
	
		else:
	
			move(_delta, 1.5)
			

	if time_for_hit[amount_hits-1] <= 0.2 and time_for_hit[amount_hits-1] > 0.14 and (enemy.global_position - enemy.player.global_position + random_pt).length() >30:
		if enemy.player!= null and ((enemy.secondary_vel).normalized() - (enemy.chase_dir)).length() < 0.7:
			enemy.velocity += enemy.secondary_vel.normalized()*  enemy.SPEED 
		elif enemy.player != null:
			enemy.velocity += enemy.chase_dir *  enemy.SPEED 
		#	move(_delta)
		
	elif time_for_hit[amount_hits-1]<= 0:
		
		enemy.animfx.scale.x =1
		enemy.animfx.scale.y =1
		
		enemy.velocity /= 3
		attack_now()
		
		amount_hits -= 1

		init_time = time_for_hit[amount_hits-1]

	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true
		timer.stop()
		enemy.player = null
		enemy.chase = false
		return idle_state
