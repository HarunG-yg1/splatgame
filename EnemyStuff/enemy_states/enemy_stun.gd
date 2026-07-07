class_name Enemy_State_Stun extends Enemy_State
@onready var timer = $"../../StateTimer"
@onready var idle_state = $"../idle"


func init() -> void:
	pass
func Enter() ->void:
	print("stun" , enemy)

	timer.start(enemy.stun)
	enemy.UpdateAnimation("idle")
	await get_tree().create_timer(0.05).timeout
	enemy.enemy_fov.get_child(0).disabled = false
	await get_tree().create_timer(0.05).timeout
	enemy.enemy_fov.get_child(1).disabled = false
	pass
	
#what happens when player enters state
func Exit() ->void:
	await get_tree().create_timer(0.05).timeout
	enemy.enemy_fov.get_child(0).disabled = false
	await get_tree().create_timer(0.05).timeout
	enemy.enemy_fov.get_child(1).disabled = false
	enemy.stun = 0
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	#print("LEMME OUT")
	#print(timer.get_time_left())
	if (enemy.velocity.length()) > 1 :

		enemy.velocity -= enemy.velocity/45  
	elif abs(enemy.velocity.length()) < 1:
		enemy.velocity = Vector2(0,0)
	if timer.get_time_left() <= 0.1:
		print("LEMME OUT")
		return idle_state
	return null
