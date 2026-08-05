class_name Player
extends CharacterBody2D



@onready var animfx = $animfx
@onready var sprite = $AttackBox/Sprite2D
@onready var statemachine : PlayerStateMachine = $statemachine
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var gun = $Gun
@onready var g_timer = $Timer
@onready var color_att_sprite : Sprite2D = $Sprite2D
@export var max_health: int = 20

var last_dir : Vector2
var is_attack := false
var is_shoot := false

var follow_up_time : float = 0



var dash_num : int = 2
var dash_cd : float = 0
var para_in_sinwave : float

var current_health: int = max_health
var is_dead: bool = false
var missed := true

var i_time : float = 0
var blocking : bool = false
var stun_time : float = 0
var jumping : bool = false
var jump_vel : float = 0.0
var crouch : bool = false

var dive_in : = false

var arr_of_blood : Array[Color] 
var curr_attk : Color

var curr_out_attked : Enemy
var curr_in_attker : Enemy
var dashing = false

const INITIAL_SPEED = 55.0
const MAX_SPEED = 320
var direction : Vector2

var last_puddle : blood_puddle



signal start_trail
signal health_changed(current: int, max: int)
signal died 

func _ready() -> void:
	RythmLoader.player = self
	Statloader.get_statsfromLoader(self)
	Statloader.player = self
	global_position = SceneManager.tp_coords
	statemachine.player = self
	current_health = max_health
	statemachine.init()
	attack_shape.disabled = true
	gun.last_colided.connect(_on_attack_box_body_entered)
	#gun.last_colided.connect(is_hit_gun)
	


func adjust_curr_attk(delta):
	if curr_attk.r < 1:
		curr_attk.r += delta/8
	else:
		curr_attk.r = 1
		
	if curr_attk.g < 1:
		curr_attk.g += delta/8
	else:
		curr_attk.g = 1
		
	if curr_attk.b < 1:
		curr_attk.b += delta/8
	else:
		curr_attk.b = 1
	color_att_sprite.modulate = curr_attk
func _process(delta: float) -> void:

	if follow_up_time > 0:
		follow_up_time -= delta
	else:
		follow_up_time = 0
		curr_out_attked = null
	adjust_curr_attk(delta)
	
	if dash_num < 2:
		dash_cd -= delta
		if dash_cd <= 0:
			dash_num += 1
			dash_cd = 0.75
	elif dash_cd > 0:
		dash_cd = 0

	if is_dead:
		return
	if Input.is_action_pressed("aim_to_mouse"):
		attack_box.look_at(get_global_mouse_position())
	else:
		print("end",round(rad_to_deg(get_angle_to(global_position+last_dir))))
		if statemachine.curr_state is not attack:
			if round(rad_to_deg(get_angle_to(global_position+last_dir))) == -90 and round(rad_to_deg(attack_box.rotation)) > 90:
				attack_box.rotation = deg_to_rad(-177)
				#
			else:
				
				attack_box.rotation = move_toward(attack_box.rotation,get_angle_to(global_position+last_dir),0.1)
	
	if i_time > 0:
		i_time -= delta

	
	jump_and_fall(delta)
	
		

	direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
		

	if direction.length() > 0:
		last_dir = direction
	
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("block") and (statemachine.curr_state is not stun):

		blocking = true
	elif  event.is_action_released("block"):
		blocking = false
	if event.is_action_pressed("crouch") and (statemachine.curr_state is not stun):
		crouch = true
	elif  event.is_action_released("crouch"):
		crouch = false 
	if event.is_action_pressed("dash") and dash_cd <= 0.15 and dash_num > 0 and (statemachine.curr_state is not stun) and !dashing:
		dashing = true
		dash_num -= 1
		dash_cd = 0.75
	
	if event.is_action_released("Attack") and (statemachine.curr_state is not stun):
		is_attack = true
		

	if event.is_action_pressed("shoot") and (statemachine.curr_state is not stun):
		is_shoot = true
	
	if event.is_action_pressed("jump") and !jumping and (statemachine.curr_state is not stun):
		jump_vel = -80
		jumping = true
		jump()
	

func jump_and_fall(delta):
	if jumping:
		#print(jump_vel)
		jump_vel += delta * 320
		para_in_sinwave += delta * 360

		#if para_in_sinwave <= 360:
			
		sprite.position.x = -10 * abs(sin(deg_to_rad(para_in_sinwave)))

	if jump_vel >= 80:
		set_collision_mask_value(7,true)
		sprite.position.x = 0
		print("yoee")
		jumping = false
		if !crouch:
			jump_vel  = 0


func move(direct,modifier=1):
	velocity = lerp(velocity, direct*MAX_SPEED* modifier,0.1)
	

func jump()->void:
	para_in_sinwave = 0
	jump_vel  =(-80)
	
	para_in_sinwave = 0
	var tween = get_tree().create_tween()

	
	tween.tween_property(sprite, "scale", Vector2(2,2), 0.25)

	tween.tween_property(sprite, "scale", Vector2(1,1), 0.25)

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
	move_and_slide()
	
func refund_dodge():
	if dash_num < 2:
		dash_num += 1
	dash_cd= 0


func _on_attack_box_body_entered(body: Enemy) -> void:
	if body != null:

		if attack_shape.disabled:
			body.damage(curr_attk,5,global_position)
			body.parried(self,1,0.6)
		else:

			
			
			
			if body.in_attk_index == 99:
				
				
				body.damage(curr_attk,0,global_position)
				body.parried(self,0.75,0.5)
				
			#	print(curr_attk, "check here" , body.name)
			
			elif body.in_attk_type.size() > body.in_attk_index:
				
				if RythmLoader.check_similiar_colour(body.in_attk_type[body.in_attk_index],Color.WHITE):
					
					body.damage(curr_attk,5,global_position)
					
					body.parried(self,0.75,0.5)
					
				elif RythmLoader.check_similiar_colour(body.in_attk_type[body.in_attk_index],curr_attk):

					if statemachine.curr_state is attack and (statemachine.old_state is moving || statemachine.old_state is idle):
						body.damage( curr_attk,4,global_position)
					else:
						body.damage( curr_attk,7,global_position)
					
					body.parried(self,0.75,0.5)
				else:

					body.damage(curr_attk, 1,global_position)
					body.parried(self,1.5,0.5)
					
				
					
				
			if body.in_attk_type.size() <= body.in_attk_index and body.in_attk_index != 99:
				body.in_attk_index = 99
				body.in_attk_type = body.in_attk_type_copy



			
			if curr_out_attked == null:
				curr_out_attked = body
				follow_up_time = 3







	

func damage(attker : Enemy, melee : bool, pwer : float):
	if is_dead:
		return
	
	curr_in_attker = attker
	if i_time <= 0 and stun_time <= 0:
		stun_time = 0.4
		current_health -= attker.damage_amnt
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			die()
	if i_time <= 0:

		velocity -=  (attker.global_position - global_position).normalized()*pwer


	pass




func die() -> void:
	print("died")
	is_dead = true
	velocity = Vector2.ZERO
	died.emit()

func check_puddle(puddle_val : Color, this_puddle : blood_puddle):
#	print("puddle check")
	var temp = last_puddle
	last_puddle =  this_puddle
	
	if  arr_of_blood.size() != 0 and puddle_val == arr_of_blood[0] and statemachine.curr_state is slide:
		dive_in = true
		visible = false
		
	else:
		if temp != null:
			last_puddle = temp
		
	pass
	
func exit_puddle(this_puddle : blood_puddle):
	if last_puddle ==  this_puddle:
		
		visible = true
		last_puddle = null
		dive_in = false

	



		
