class_name ranged extends Enemy

var check_if_ray_hit : PhysicsBody2D
func _ready() -> void:
	
	state_machine.init()
	hitter = $RayCast2D
	pass # Replace with function body.

func _process(delta: float) -> void:
	
		
	if player != null and chase == true:
		chase_dir = (player.position-position).normalized()
	#	hitter.look_at(player.position)
	if velocity.length() > 0:
		enemy_fov.position = velocity.normalized()*70
		enemy_fov.rotation =  (velocity).angle()
	pass
	
func _physics_process(delta: float) -> void:
	boids()
	
	move_and_slide()
	
	
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	if new_dir == cardinal_direction:
		#print(cardinal_direction)
		return false
	cardinal_direction = new_dir
	#sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

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
		
		body.damage(1,global_position, self, 100,false)
		
	await get_tree().create_timer(0.2).timeout
	animsprite.play("default")

		
func parried( from : Vector2):
	print("sa parried")
	if stun <= 0:
		stun = 1
	velocity -=  (from - global_position).normalized() * 800
	pass

func queue_anim(anim:String = "", resize_y : float = 1, resize_x : float = 1, state : enemy_attack = null):
	await animfx.animation_finished

	animfx.scale.y = resize_y
	animfx.scale.x = resize_x
	
#await animfx.animation_finished
	
	state.attack_now()
	await get_tree().create_timer(0.12).timeout
	animfx.play(anim)
	
	return true
