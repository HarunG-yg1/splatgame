class_name RangeNMeleeEnemy extends ranged

func _process(delta: float) -> void:
	if stun < -0.05:
		stun += delta
	elif  stun < 0 and stun > -0.05:
		stun = 0
		
	if player != null and chase == true:
		chase_dir = (player.position-position).normalized()
		hitter.get_parent().look_at(player.position)
	if velocity.length() > 0:
		enemy_fov.position = velocity.normalized()*70
		enemy_fov.rotation =  (velocity).angle()
	pass
	
func _physics_process(delta: float) -> void:
	boids()
	
	move_and_slide()

	
