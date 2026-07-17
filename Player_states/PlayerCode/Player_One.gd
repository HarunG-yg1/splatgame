class_name Player
extends CharacterBody2D



@onready var animfx = $animfx
@onready var sprite = $AttackBox/Sprite2D
@onready var statemachine = $statemachine
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var gun = $Gun
@onready var g_timer = $Timer

@export var max_health: int = 20

var last_dir : Vector2
var is_attack := false
var is_shoot := false

signal check_knockback

var dash_num : int = 2
var dash_cd : float = 0
var para_in_sinwave : float

var current_health: int = max_health
var is_dead: bool = false
var missed := true

var i_time : float = 0
var blocking : bool = false
var stun : float = 0
var jumping : bool = false
var jump_vel : float = 0.0
var crouch : bool = false

var dive_in : = false

var arr_of_blood : Array[blood_puddle.puddle_colors] 
var curr_attk : blood_puddle.puddle_colors

var curr_out_attked : Enemy
var curr_in_attker : Enemy
var dashing = false

const INITIAL_SPEED = 55.0
const MAX_SPEED = 320
var direction : Vector2

var last_puddle : blood_puddle

#var curr_hitEnemy : Enemy = null



signal health_changed(current: int, max: int)
signal died 

func _ready() -> void:
	RythmLoader.player = self
	Statloader.get_statsfromLoader(self)
	Statloader.player = self
	global_position = SceneManager.tp_coords
	statemachine.player = self
	
	statemachine.init()
	attack_shape.disabled = true
	gun.last_colided.connect(_on_attack_box_body_entered)
	#gun.last_colided.connect(is_hit_gun)
	


func _process(delta: float) -> void:
	if dash_num < 2:
		dash_cd -= delta
		if dash_cd <= 0:
			dash_num += 1
			dash_cd = 0.75
	elif dash_cd > 0:
		dash_cd = 0

	if is_dead:
		return
	
	attack_box.look_at(get_global_mouse_position())
	if i_time > 0:
		i_time -= delta
	if stun > 0:
		stun -= delta
	
	jump_and_fall(delta)
	
		
	if (stun <= 0 || stun > 0.8):
		direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
		
	else:
		direction = Vector2.ZERO
	if direction.length() > 0:
		last_dir = direction

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("block"):

		blocking = true
	else:
		blocking = false
	if event.is_action_pressed("crouch"):
		crouch = true
	elif  event.is_action_released("crouch"):
		crouch = false 
	if event.is_action_pressed("dash") and dash_cd <= 0.15 and dash_num > 0 and stun < 0.5 and !dashing:
		dashing = true
		dash_num -= 1
		dash_cd = 0.75
	
	if event.is_action_released("Attack") and stun <= 0.1:
		is_attack = true
		

	if event.is_action_pressed("shoot") and stun <= 0.1:
		is_shoot = true
	
	if event.is_action_pressed("jump") and !jumping:
		#jump_vel = 0
		jumping = true
		jump()
	

func jump_and_fall(delta):
	if jumping:
		#print(jump_vel)
		jump_vel += delta * 320
		para_in_sinwave += delta * 640

		#if para_in_sinwave <= 360:
			
		sprite.position.y += 20 * -(sin(deg_to_rad(para_in_sinwave)))*0.02

	if jump_vel >= 80:
		set_collision_mask_value(7,true)
		sprite.position.y = 0
		jumping = false
		if !crouch:
			jump_vel  = 0


func move(direct,modifier=1):
	if ((direct.length()) > 0.0 and abs(velocity.length()) <  MAX_SPEED):
		velocity += (direct * INITIAL_SPEED) *modifier
	elif (direct.length()) > 0.0 and (abs(velocity.length()) >=  MAX_SPEED):
		velocity -=  velocity/4 - (direct* INITIAL_SPEED)*modifier

func jump()->void:
	para_in_sinwave = 0
	jump_vel  =(-80)
	
	para_in_sinwave = 0
	var tween = get_tree().create_tween()

	
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.25)

	tween.tween_property(sprite, "scale", Vector2(0.5,0.5), 0.25)

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
		print(body.stun,"stun")
		if attack_shape.disabled:
			body.damage(5,global_position)
			body.parried(self,1,0.6)
		else:
			
			curr_out_attked = body
			
			if curr_attk == blood_puddle.puddle_colors.NO_COLOR:
				check_knockback.emit(true,body)
			
			if body.in_attk_index == 99:
				body.in_attk_index = randi_range(0,7)
				
				body.damage(0,global_position)
				body.parried(self,0.75,1.2)
				#print(curr_attk, "check here")
			
			elif body.in_attk_type.size() > body.in_attk_index:
				if body.in_attk_type[body.in_attk_index] == blood_puddle.puddle_colors.NO_COLOR:
					body.damage(5,global_position)
				elif body.in_attk_type[body.in_attk_index] == curr_attk:
					
					if curr_attk == blood_puddle.puddle_colors.GREEN || curr_attk == blood_puddle.puddle_colors.BLUE:
						body.damage( 7,global_position)
					elif curr_attk == blood_puddle.puddle_colors.RED:
						body.damage( 10,global_position)
				
			if body.in_attk_type.size() < body.in_attk_index:
				body.in_attk_index = 99
				body.parried(self,2)
			else:
				body.in_attk_index += 1
				body.parried(self,1,1.5)


		
			
		#velocity += body.velocity






	

func damage(attker : Enemy, melee : bool, pwer : float):
	if is_dead:
		return
	
	curr_in_attker = attker
	if i_time <= 0 and stun <= 0:
		stun = 0.5
		current_health -= attker.damage_amnt
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			die()
	
		velocity -=  (attker.global_position - global_position).normalized()*pwer


	pass




func die() -> void:
	print("died")
	is_dead = true
	velocity = Vector2.ZERO
	died.emit()

func check_puddle(puddle_val : int, this_puddle : blood_puddle):
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
	pass
	


func _on_check_knockback(follow:bool, flourishee : Enemy) -> void:
	g_timer.start(0.1)
	
	await g_timer.timeout
	
	if flourishee != null  and follow: 
		direction = (global_position - flourishee.global_position ).normalized()
		if flourishee.velocity.length() < 800:
			velocity -= (global_position - flourishee.global_position ).normalized()*800
			g_timer.start(0.25)
		else:
			velocity += flourishee.velocity 
			g_timer.start(0.2)
		
