class_name RangeNMeleeEnemy extends ranged

func Process(delta: float) -> void:
	
	
	was_last_hit += delta
	if was_last_hit >= 0.25 and !get_collision_mask_value(2):

		set_collision_mask_value(2,true)
	stun_time = move_toward(stun_time,0,delta)
	is_not_move = pos_check(delta)
		
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

	
