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
@onready var gen_timer = $"../../general_timer"
var init_time : float
#what happens when player enters state
func Enter() ->void:

	enemy.stun = 0
	print("attack" , enemy)
	time_on_player = 0
	gen_timer.start(6)
	var acc : float = 0

	amount_hits= randi_range(3,8)
	for i : int in range(amount_hits-1):
		
		time_for_hit[i] = enemy.out_attk_time[amount_hits - i - 1]
		color_for_hit[i] = enemy.out_attk_color[amount_hits - i - 1]
		
	print(enemy.out_attk_time.size())
	time_for_hit[amount_hits-1] += 0.5
	init_time = time_for_hit[amount_hits-1]
	enemy.random_pt =  Vector2(randi_range(-7,7),randi_range(-7,7))
	

	was_out_of_range = true

	
#what happens when player enters state
func Exit() ->void:

	RythmLoader.interrupt(enemy)


func Process(_delta:float)->Enemy_State:
	
	if enemy.stun > 0 and gen_timer.get_time_left() <= 1 :

		print("can attack")
		enemy.enemy_fov.get_child(0).disabled = true

		if enemy.player != null:
			enemy.player.refund_dodge()
			enemy.player = null
		enemy.chase = false
		return stun_state 
	else:
		print( gen_timer.get_time_left(), "time attk")
		enemy.stun = 0
	if (enemy.player!= null and time_on_player < 0.25) || ( enemy.player!= null and (enemy.global_position - enemy.player.global_position + enemy.random_pt ).length() > 160):
		if !was_out_of_range:
			
			was_out_of_range = true
			time_for_hit[amount_hits-1]+= 0.5
			RythmLoader.interrupt(enemy)
		return move(_delta,1.2)
		
	
	elif  enemy.player!= null and time_on_player > 0.25 :
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
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 80:
		time_on_player -= delta
		enemy.direction = enemy.chase_dir
	if enemy.player!= null and ((enemy.global_position - enemy.player.global_position + random_pt).normalized() - (enemy.direction)).length() < 0.7  and (enemy.global_position - enemy.player.global_position).length() > 60:
		
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.2).normalized()) * enemy.SPEED * modifier , 0.1) 
	elif enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 60:
		time_on_player += delta
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction*1.05).normalized()) * enemy.SPEED * modifier , 0.1)
	else:
		if  enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() < 60:
			time_on_player += delta
			if (enemy.global_position - enemy.player.global_position + random_pt).length() < 25:
				enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() - enemy.direction*1.05).normalized()) * enemy.SPEED * 0.2 , 0.1)
			elif (enemy.global_position - enemy.player.global_position + random_pt).length() < 50:
				enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + Vector2(enemy.direction.y,enemy.direction.x)*1.05).normalized()) * enemy.SPEED * modifier * 0.1 , 0.25)


func attack_rythm(_delta):
	
	time_for_hit[amount_hits-1]  -= _delta
	if time_for_hit[amount_hits-1] > init_time * 0.2:
		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() >60:
			enemy.velocity = lerp(enemy.velocity,enemy.chase_dir *  enemy.player.MAX_SPEED , 0.1) 
		else:
			move(_delta)
			

	if time_for_hit[amount_hits-1] <= init_time * 0.2 and time_for_hit[amount_hits-1] > init_time * 0.19:
		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() < 60:
			enemy.velocity = enemy.chase_dir *  enemy.player.MAX_SPEED * 1.25
		else:
			move(_delta)
		
	elif time_for_hit[amount_hits-1]<= 0:
		enemy.animfx.scale.x =1
		enemy.animfx.scale.y =1
		

		

		if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() < 80:
			enemy.velocity =  lerp(enemy.velocity, Vector2.ZERO,2)

		attack_now()

		amount_hits -= 1

		init_time = time_for_hit[amount_hits-1]

	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true

		enemy.player = null
		enemy.chase = false
		return idle_state
