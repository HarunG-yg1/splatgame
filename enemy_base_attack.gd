class_name enemy_attack extends Enemy_State 
func init() -> void:
	pass
var random_pt : Vector2
var amount_hits : int
var was_out_of_range := true
var time_for_hit : Array[float]

var hit_cooldown: float = 0.0 # time before next attack can commence
const ATTACK_DELAY: float = 1.0 # seconds between hits

var rhythm_count: int = 0 # how many beats left for the player to hit
var can_rhythm_be_beated: bool = false # true if enemy is attacking

@onready var idle_state =$"../idle"
@onready var stun_state =$"../stun"
#what happens when player enters state
func Enter() ->void:
	#print("noop")
	enemy.random_pt =  Vector2(randi_range(-15,15),randi_range(-15,15))
	time_for_hit = [0.5,0.45,0.45,0.45,0.45,0.45,0.45,0.45]
	random_pt = Vector2(randi_range(-25,25),randi_range(-25,25))
	amount_hits= randi_range(3,8)
	time_for_hit[amount_hits-1] += 0.5
	was_out_of_range = true
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state

func Process(_delta:float)->Enemy_State:
	
	if enemy.stun > 0:
		
		return stun_state 
	
	if enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position + random_pt).length() > 40:
		if !was_out_of_range:
			time_for_hit[amount_hits-1] += 0.25
		was_out_of_range = true
		move()
	elif  enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position+ random_pt).length() <40:
		was_out_of_range =  false
		if (enemy.hitter.global_position - enemy.player.global_position+ random_pt).length() > 20:
			enemy.velocity =  enemy.chase_dir * enemy.player.MAX_SPEED * 1.1
		else:
			enemy.velocity = lerp(enemy.velocity,Vector2.ZERO,0.1)
		time_for_hit[amount_hits-1] -= _delta
		
		# does not allow attack again if the enemy has attacked for a short duration
		if hit_cooldown > 0:
			hit_cooldown -= _delta
		
			# disable hitbox after a short duration
			if hit_cooldown <= (ATTACK_DELAY - 0.2):
				enemy.hitter.disabled = true
				can_rhythm_be_beated = false
				
		if hit_cooldown <= 0 and amount_hits > 0:
			attack_now()
			hit_cooldown = ATTACK_DELAY
		
	#visual cue for the player to know when to m1 to negate
	if hit_cooldown <= 0.2:
		enemy.animfx.play("shine")
		#if time_for_hit[amount_hits-1] <= 0.5:
			#print("attack")
			#enemy.animfx.play("shine")
		#if time_for_hit[amount_hits-1] <= 0:
			#attack_now()
		#
			#enemy.animsprite.play("hit")
			#amount_hits -= 1
		
	if enemy.SetDirection():
		enemy.AnimDirect()
		enemy.UpdateAnimation("walk")
	
	#enemy.AnimDirect()
	if amount_hits <=0:
		enemy.player = null
		enemy.chase = false
		return idle_state
	return null

func attack_now():
	if enemy.player != null:
		enemy.hitter.disabled = false
		can_rhythm_be_beated = true
		enemy.animsprite.play("hit")
		amount_hits -= 1
		
		# so the hit window is 0.2 seconds
		#await get_tree().create_timer(1.0).timeout
		#can_rhythm_be_beated = false
		#
		# disabling the hitter box after the attack	
		#await get_tree().create_timer(1.0).timeout
		#enemy.hitter.disabled = true
	pass

func move():
	if enemy.player!= null and (enemy.global_position - enemy.player.global_position + random_pt).length() > 80:
		
		enemy.direction = enemy.chase_dir
	if enemy.player!= null and ((enemy.global_position - enemy.player.global_position + random_pt).normalized() - (enemy.direction)).length() < 0.7  and (enemy.hitter.global_position - enemy.player.global_position).length() > 60:
	#	print("chase bro son")
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/4).normalized()) * enemy.SPEED * 2.4  , 0.1)
	elif enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position + random_pt).length() > 60:
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction*1.05).normalized()) * enemy.SPEED *2.4 , 0.1)
	elif enemy.player!= null and (enemy.hitter.global_position - enemy.player.global_position + random_pt).length() <40:
		enemy.velocity =  lerp(enemy.velocity,((enemy.secondary_vel.normalized() + enemy.direction/1.05).normalized()) * enemy.SPEED * 2 , 0.1)


		
