class_name shoot extends attack

func Exit():
	guy1.is_shoot = false
	guy1.signal_attk = false
	pass
#	
func missed_target():
	rec_enemy.in_attk_time_index = 0
	guy1.curr_hitEnemy.parried(guy1.global_position,0,-1.5)
	print( guy1.out_attk_time ,"truke")
	guy1.gun_has_timed = false
	
	guy1.curr_hitEnemy = null

func hurt_target():
	if guy1.curr_hitEnemy != null:
			print("hitt")
			print( guy1.out_attk_time ,"truke")
			guy1.curr_hitEnemy.in_attk_time_index += 1
			guy1.curr_hitEnemy.damage(1,guy1.global_position)
			guy1.curr_hitEnemy.parried(guy1.global_position,0.8,1)
			

			guy1.gun_has_timed = true 
				
				
			if rec_enemy.in_attk_time_index < rec_enemy.in_attk_time.size():
				guy1.out_attk_time = rec_enemy.in_attk_time[rec_enemy.in_attk_time_index]
			else:
				rec_enemy.in_attk_time_index = 0
				guy1.curr_hitEnemy.damage(1,guy1.global_position)
				guy1.curr_hitEnemy.parried(guy1.global_position,1.5,1)

				guy1.curr_hitEnemy = null
func first_con()->bool:
	guy1.sprite.stop()
	guy1.sprite.play("Shoot")
	return guy1.signal_attk and guy1.same_guy and rec_enemy != null and guy1.out_attk_time < 0.1 and guy1.out_attk_time > -0.25
