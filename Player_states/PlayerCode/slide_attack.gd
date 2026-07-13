class_name slide_attack extends attack

var prior_vel : Vector2
var changed_dir := false

	
func Enter():
	
	changed_dir = false
	prior_attack_box_size = guy1.attack_shape.shape.size.x
	prior_attack_box_displace = guy1.attack_shape.position.x
	guy1.attack_shape.shape.size.x *= 1.6
	guy1.attack_shape.position.x -= 24
	print("SlideAttack")
	if Input.is_action_pressed("aim_to_mouse"):
		prior_vel =  -(guy1.global_position - guy1.get_global_mouse_position()).normalized() * guy1.velocity.length() 
		guy1.velocity = prior_vel
		
	elif guy1.curr_out_attked == null:
		
		prior_vel = guy1.velocity
		
	else:
		prior_vel = -(guy1.global_position - guy1.curr_out_attked.global_position).normalized() * guy1.velocity.length() 
		guy1.velocity = prior_vel
	guy1.curr_attk = 2
	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineGreen")
	timer = 0.6
	
func hit_boxOn()->bool:
	return timer <=0.3 and  timer > 0.29
	
func attack_movement(delta):
	

	guy1.attack_box.look_at(guy1.position+guy1.velocity)
#	print("sliding")
	prior_vel *= 0.97
	if guy1.get_last_slide_collision() != null and guy1.get_last_slide_collision() != Enemy and !changed_dir:
	
	
		var temp_prior_vel = (prior_vel.normalized() + 2*guy1.get_last_slide_collision().get_normal()).normalized() * guy1.velocity.length()
		if( guy1.get_last_slide_collision().get_normal().x >0) :
			prior_vel.x = abs(temp_prior_vel.x)
		else:
			prior_vel.x = -abs(temp_prior_vel.x)
		if( guy1.get_last_slide_collision().get_normal().y >0) :
			prior_vel.y = abs(temp_prior_vel.y)
		else:
			prior_vel.y = -abs(temp_prior_vel.y)
		changed_dir = true
		
		guy1.velocity = prior_vel
		print(guy1.get_last_slide_collision().get_normal(),"privel1")
		print(prior_vel,"privel")
		
	if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:

		guy1.velocity= guy1.velocity.normalized() *50
	else:

		
		if !guy1.attack_shape.disabled:
			guy1.velocity = (prior_vel + guy1.direction*150)*3
		else:
			guy1.velocity = (prior_vel + guy1.direction*150)
