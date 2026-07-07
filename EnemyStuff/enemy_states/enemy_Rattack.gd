class_name enemy_range_atack extends enemy_attack
var juke : bool = false
var player : Player

var changed : bool = false
var init_time : float
func _ready() -> void:
	chase_state = $"../chase"
	idle_state = $"../idle"
	stun_state = $"../stun"
	pass
	
func Exit() ->void:
	pass
	
func Enter() ->void:
	print("range" , enemy)
	player =  enemy.player
	#print("noop")
	enemy.random_pt =  Vector2(randi_range(-15,15),randi_range(-15,15))
	time_for_hit = [0.55,0.55,0.55,0.55,1.5,0.55,0.55,0.55]
	
	random_pt = Vector2(randi_range(-25,25),randi_range(-25,25))
	amount_hits= randi_range(3,8)
	time_for_hit[amount_hits-1] += 0.5
	init_time = time_for_hit[amount_hits-1]
	was_out_of_range = true
	pass

func Process(_delta:float)->Enemy_State:
	if enemy.stun > 0:
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return stun_state 

	if abs(rad_to_deg(enemy.hitter2.rotation - enemy.get_angle_to(player.global_position))) > 20:
		
		enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(player.global_position),0.06)
	else:
		enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(player.global_position),0.0099)
	if player != null and (enemy.global_position - player.global_position).length() > 120 and (enemy.global_position - player.global_position).length() < 720 and abs(rad_to_deg(enemy.hitter2.rotation - enemy.get_angle_to(player.global_position))) <6:
		
		was_out_of_range = false
		if enemy.hitter2.get_collider() is Player:
			return attack_rythm(_delta)
	else: 
		if !was_out_of_range:
			time_for_hit[amount_hits-1] = 1
		
		was_out_of_range = true
		return move()

	return null

func attack_now():
	if enemy.hitter2.get_collider() is Player:
		await get_tree().create_timer(0.05).timeout
		enemy.attk_hitted(enemy.player)
	
		pass

func attack_rythm(_delta):
	time_for_hit[amount_hits-1] -= _delta
	if (time_for_hit[amount_hits-1] < init_time * 0.9 and time_for_hit[amount_hits-1] > init_time * 0.01) ||(time_for_hit[amount_hits-1] <= 0.5 and time_for_hit[amount_hits-1] > 0.005):
		

		enemy.animfx.rotation = enemy.hitter2.rotation
		if !changed:
			enemy.animfx.scale.y =1
			enemy.animfx.scale.x =25

			enemy.animfx.play("shine2")

			changed= true

			
		
		
	elif time_for_hit[amount_hits-1] <= 0:


		enemy.queue_anim("shine", 2,25,self)
		enemy.animsprite.play("hit")
		
		
		amount_hits -= 1
		#time_for_hit[amount_hits-1] += 0.2
		init_time = time_for_hit[amount_hits-1]
		changed= false
	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true
		enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return idle_state
	

func move():
	if player != null and (enemy.global_position - player.global_position).length() < 70:
			return chase_state
	if juke:
		enemy.velocity =  lerp(enemy.velocity,((enemy.direction).normalized()) * enemy.SPEED * 1.8 , 0.1)
	if !juke and enemy.player!= null and  enemy.player!= null and( enemy.direction - enemy.player.velocity.normalized()).length() < 1.4 and enemy.player.velocity.length() > 0 and (enemy.global_position - enemy.player.global_position ).length() <80:
		enemy.direction = enemy.chase_dir
		
		juke = true
	if juke and  enemy.player!= null and (enemy.global_position - enemy.player.global_position ).length() >90 :
		
		juke = false
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/4).normalized()) * enemy.SPEED *1.5 , 0.1)
