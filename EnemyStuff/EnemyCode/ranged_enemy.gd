class_name ranged extends Enemy

@onready var hitter2 : =$RayCast2D
@onready var animfx2 : =$AnimatedFX2
func _ready() -> void:
	animsprite.play("default")
	state_machine.init()
	#hitter = $RayCast2D
	pass # Replace with function body.

func Process(delta: float) -> void:
	was_last_hit += delta
	
	stun_time = move_toward(stun_time,0,delta)
		
	if player != null and chase == true:
		chase_dir = (player.position-position).normalized()

	if velocity.length() > 0:
		enemy_fov.position = velocity.normalized()*70
		enemy_fov.rotation =  (velocity).angle()
	pass
	

	
	

func UpdateAnimation(state : String) -> void:
	#animation_player.play(state + "_" + AnimDirect())
	pass
	
func AnimDirect() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func choose_randomly(list_of_entries):
	return list_of_entries[randi() % list_of_entries.size()]
	





func _on_enemy_fov_body_entered(body: CharacterBody2D) -> void:
	if body is Player   :
		chase = true
		player = body

	bodyIsee.append(body)


func _on_enemy_fov_body_exited(body: CharacterBody2D) -> void:
	if player == body and !chase:
		player = null
	if (body.global_position - global_position).length() > 80:
		bodyIsee.erase(body)
		
		
func attk_hitted(body : PhysicsBody2D):

	if body is Player:
		print("yo")
		if body.missed:
			body.damage(self, false,100)
			body.missed = false

		g_timer.start(0.2)
		await g_timer.timeout
		
		animsprite.play("default")

	#animsprite.play("default")
