class_name Enemy_State_Idle extends Enemy_State
##ref to what this state belongs to
@onready var timer = $"../../StateTimer"
@onready var attack_state  = $"../attack"
@onready var roam =$"../roam"
@onready var chasing =$"../chase"
@onready var runaway =$"../runAway"
#what happens when player enters state
func init() -> void:
	pass
func Enter() ->void:
	#print("idle")
	if enemy.hitter is RayCast2D:
		enemy.hitter.enabled = true
	timer.start(enemy.choose_randomly([0.5,1.5,2,1]))
	enemy.UpdateAnimation("idle")
	pass
	
#what happens when player enters state
func Exit() ->void:
	if enemy.hitter is RayCast2D:
		enemy.hitter.enabled = false
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	if enemy.hitter is RayCast2D:
		enemy.hitter.rotation += deg_to_rad(0.1)
		if enemy.hitter.get_collider() != null and  enemy.hitter.get_collider() is Player:
			enemy.player =  enemy.hitter.get_collider()
			enemy.chase = true
			
	enemy.velocity = lerp (enemy.velocity,Vector2.ZERO,0.1)
	if enemy.chase and chasing != null:
		print("run bro")
		return chasing
		
	elif  enemy.chase and runaway != null:
		
		return runaway
	if timer.get_time_left() <= 0.1:
		
		return roam
	return null
