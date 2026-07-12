class_name enemy_range_atack extends enemy_attack
var juke : bool = false


var changed : bool = false

func _ready() -> void:
	chase_state = $"../chase"
	idle_state = $"../idle"
	stun_state = $"../stun"
	pass
	
func Exit() ->void:
	pass
	


func Process(_delta:float)->Enemy_State:
	if enemy.stun > 0:
		enemy.enemy_fov.get_child(0).disabled = true
	#	enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return stun_state 

	if enemy.player != null and abs(rad_to_deg(enemy.hitter2.rotation - enemy.get_angle_to(enemy.player.global_position))) > 20:
		if !was_out_of_range:
			RythmLoader.interrupt(enemy)
			
			was_out_of_range = true
		enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(enemy.player.global_position),0.06)
	elif enemy.player != null:
		enemy.hitter2.rotation = move_toward(enemy.hitter2.rotation ,enemy.get_angle_to(enemy.player.global_position),0.0099)
	if enemy.player != null and (enemy.global_position - enemy.player.global_position).length() > 120 and (enemy.global_position - enemy.player.global_position).length() < 720 and abs(rad_to_deg(enemy.hitter2.rotation - enemy.get_angle_to(enemy.player.global_position))) <6:
		if was_out_of_range:
			time_for_hit[amount_hits-1].time += 0.3
			RythmLoader.addTo_hitline(time_for_hit,enemy)
			
			was_out_of_range =  false

		if enemy.hitter2.get_collider() is Player:
			return attack_rythm(_delta)
	else: 
		if !was_out_of_range:
			RythmLoader.interrupt(enemy)
			
			was_out_of_range = true
			
			

		return move(_delta)

	return null

func attack_now():
	if enemy.hitter2.get_collider() is Player:
		enemy.player = enemy.hitter2.get_collider()
		enemy.attk_hitted(enemy.player)

		#enemy.player.missed = false
		

func attack_rythm(_delta):
	time_for_hit[amount_hits-1].time -= _delta
	if (time_for_hit[amount_hits-1].time < init_time * 0.75 and time_for_hit[amount_hits-1].time > init_time * 0.74)|| init_time < 0.6 and (time_for_hit[amount_hits-1].time < init_time and time_for_hit[amount_hits-1].time > init_time * 0.9):
		

		enemy.animfx.rotation = enemy.hitter2.rotation

		enemy.animfx.scale.y =0.5
		enemy.animfx.scale.x =25



	elif (time_for_hit[amount_hits-1].time <= 0.3 and time_for_hit[amount_hits-1].time > 0.28):
		enemy.animfx.rotation = enemy.hitter2.rotation

		#enemy.animfx.play("shine1")

	elif time_for_hit[amount_hits-1].time <= 0:
		enemy.animfx2.rotation = enemy.hitter2.rotation
		#enemy.animfx.scale.y =1
		enemy.animfx2.play("shine3")

		enemy.animsprite.play("hit")
		
		attack_now()
		amount_hits -= 1
		#time_for_hit[amount_hits-1] += 0.2
		#init_time = time_for_hit[amount_hits-1]

	if amount_hits <=0:
		enemy.enemy_fov.get_child(0).disabled = true
	#	enemy.enemy_fov.get_child(1).disabled = true
		enemy.player = null
		enemy.chase = false
		return idle_state
	

func move(delta : float ,modifier : float = 1):
	if enemy.player != null and (enemy.global_position - enemy.player.global_position).length() < 70:
			return chase_state
	if juke:
		enemy.velocity =  lerp(enemy.velocity,((enemy.direction).normalized()) * enemy.SPEED  , 0.1)
	if !juke and enemy.player!= null and  enemy.player!= null and( enemy.direction - enemy.player.velocity.normalized()).length() < 1.4 and enemy.player.velocity.length() > 0 and (enemy.global_position - enemy.player.global_position ).length() <80:
		enemy.direction = enemy.chase_dir
		
		juke = true
	if juke and  enemy.player!= null and (enemy.global_position - enemy.player.global_position ).length() >90 :
		
		juke = false
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/4).normalized()) * enemy.SPEED, 0.1)
