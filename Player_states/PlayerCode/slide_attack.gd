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
	guy1.velocity *= 1.6
	if guy1.curr_out_attked == null:
		prior_vel = guy1.velocity#.normalized()
	else:
		prior_vel = -(guy1.global_position - guy1.curr_out_attked.global_position).normalized() * guy1.velocity.length()
	
	guy1.curr_attk = 2
	guy1.sprite.play("BasicATK")
	guy1.animfx.play("shineGreen")
	timer = 0.4
	
func hit_boxOn()->bool:
	return timer <0.35 and  timer > 0.34
	
func attack_movement(delta):
	#if guy1.direction.length() > 0.0:
	guy1.attack_box.look_at(guy1.position+guy1.velocity)
#	print("sliding")
	prior_vel *= 0.98
	if guy1.get_last_slide_collision() != null and guy1.get_last_slide_collision() != Enemy and !changed_dir:
	
	
		prior_vel = (prior_vel.normalized() - guy1.get_last_slide_collision().get_normal()).normalized() * guy1.velocity.length()
		if( prior_vel.x > 0 and  guy1.get_last_slide_collision().get_normal().x < 0) || (prior_vel.x < 0 and  guy1.get_last_slide_collision().get_normal().x > 0):
			prior_vel.x *= -1

		if (prior_vel.y > 0 and  guy1.get_last_slide_collision().get_normal().y < 0) || (prior_vel.y < 0 and  guy1.get_last_slide_collision().get_normal().y > 0):
			prior_vel.y *= -1
		
		guy1.velocity = prior_vel
		print(guy1.get_last_slide_collision().get_normal(),"privel1")
		print(prior_vel,"privel")
		changed_dir = true
	if (guy1.velocity.normalized()  -prior_vel.normalized()).length() > 1.4:

		guy1.velocity= guy1.velocity.normalized() *50
	else:
		guy1.velocity = prior_vel + guy1.direction*150
		
