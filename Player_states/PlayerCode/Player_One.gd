class_name Player
extends CharacterBody2D
var para_in_sinwave : float
@onready var animfx = $animfx
@onready var sprite = $AttackBox/Sprite2D
@onready var statemachine = $statemachine
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D
@onready var gun = $Gun
@export var max_health: int = 20

var is_attack := false
var is_shoot := false
signal check_knockback


var health_dec : int

var current_health: int = max_health
var is_dead: bool = false

var i_time : float = 0
var blocking : bool = false
var stun : float = 0
var jumping : bool = false
var jump_vel : float = 0.0
var crouch : bool = false
var player_damage : int = 10
var dive_in : = false

var arr_of_blood : Array[int] 

var in_attk_time  : float 
var out_attk_time  : float 
var signal_attk : bool = false

var run = false
var finish_run = true
const INITIAL_SPEED = 55.0
const MAX_SPEED = 320
var direction : Vector2

var last_puddle : blood_puddle
var curr_attker : Enemy = null
var curr_hitEnemy : Enemy = null
var same_guy : = true
var gun_has_timed : = false

signal health_changed(current: int, max: int)
signal died 

func _ready() -> void:
	Statloader.get_statsfromLoader(self)
	global_position = SceneManager.tp_coords
	statemachine.player = self
	Statloader.player = self
	statemachine.init()
	attack_shape.disabled = true
	gun.last_colided.connect(_on_attack_box_body_entered)
	gun.last_colided.connect(is_hit_gun)
	


func _process(delta: float) -> void:
	if is_dead:
		return
	
	attack_box.look_at(get_global_mouse_position())
	if i_time > 0:
		i_time -= delta
	if stun > 0:
		stun -= delta*2
	in_attk_time-=delta
	if in_attk_time<-0.15  and in_attk_time<-0.16:
		damage_dec()

	out_attk_time-= delta

	if out_attk_time < 0.4 and out_attk_time > 0.39:

		animfx.stop()
		animfx.play("shineMelee")
	
	if Input.is_action_just_pressed("block"):

		blocking = true
	else:
		blocking = false
	if Input.is_action_pressed("crouch"):
		crouch = true
	else:
		crouch = false 
	if Input.is_action_pressed("dash") and stun < 0.5 and finish_run and !run and velocity.length()>0:
		run = true
		finish_run = false
		await get_tree().create_timer(1).timeout
		run = false
	
	if Input.is_action_just_pressed("Attack") and stun <= 0.1:
		attack_fr()
	if Input.is_action_just_pressed("shoot") and stun <= 0.1:
		await get_tree().create_timer(0.15).timeout
		is_shoot = true
	
	if Input.is_action_just_pressed("jump") and !jumping:
		#jump_vel = 0
		jumping = true
		jump()
	
	jump_and_fall(delta)
	
		
	if stun <= 0 || stun > 0.8:
		direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
	else:
		direction = Vector2.ZERO
func attack_fr():
	
	attack_shape.disabled = false 
	
	await get_tree().create_timer(0.1).timeout
	is_attack = true
	await get_tree().create_timer(0.1).timeout
	attack_shape.disabled = true
	
	
	

func jump_and_fall(delta):
	if jumping:
		print(jump_vel)
		jump_vel += delta * 160
		para_in_sinwave += delta * 320 * 2

		#if para_in_sinwave <= 360:
			
		sprite.position.y += 20 * -(sin(deg_to_rad(para_in_sinwave)))*0.04

	if jump_vel >= 80:
		set_collision_mask_value(7,true)
		sprite.position.y = 0
		jumping = false
		


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

	
	tween.tween_property(self, "scale", Vector2(1.5,1.5), 0.3)

	tween.tween_property(self, "scale", Vector2(1,1), 0.3)

func _physics_process(_delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
	move_and_slide()
	
	


func _on_attack_box_body_entered(body: Enemy) -> void:
	if body != null:
		if body != curr_hitEnemy and curr_hitEnemy ==null :
			curr_hitEnemy = body
			if !attack_shape.disabled:
				body.damage(4,global_position)
			else:
				body.damage(1,global_position)
			body.parried(global_position,0.8,body.in_attk_time[body.in_attk_time_index])

			velocity += body.velocity
			if body.in_attk_time_index < body.in_attk_time.size():
				out_attk_time =  body.in_attk_time[body.in_attk_time_index]
			else:
				body.in_attk_time_index = 0
			
		elif body != curr_hitEnemy and curr_hitEnemy !=null :
			curr_hitEnemy = body
			body.damage(0,global_position)
			body.parried(global_position,0.8,body.in_attk_time[body.in_attk_time_index])
			same_guy = false
		elif body == curr_hitEnemy and curr_hitEnemy !=null :

			same_guy = true
		
		
		
		signal_attk = true
		if out_attk_time< 1:
			animfx.play("shine2")
		else:
			
			animfx.play("shineBlue")


func is_hit_gun(last_collide : Enemy):
	if gun_has_timed and last_collide != null:

		last_collide.damage(4,global_position)
		last_collide.parried(global_position,0.8,last_collide.in_attk_time[last_collide.in_attk_time_index])

	

func damage(amnt : int , from : Vector2, attker : Enemy, pwer : float, melee : bool):
	if is_dead:
		return
	in_attk_time = 0.3
	curr_attker = attker
	if i_time <= 0 and stun <= 0:
		stun = 1
		
		health_dec += amnt
		if !melee:
			velocity -=  (from - global_position).normalized() * pwer
	if melee:
		velocity -=  (from - global_position).normalized() * pwer
	pass

func damage_dec():
	if health_dec >0:
		current_health -= health_dec
		health_dec = 0
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			die()
	


func die() -> void:
	print("died")
	is_dead = true
	velocity = Vector2.ZERO
	died.emit()

func check_puddle(puddle_val : int, this_puddle : blood_puddle):
	print("puddle check")
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
	await get_tree().create_timer(0.02).timeout
	
	if !flourishee.is_not_move and follow: 
		velocity -= (global_position - flourishee.global_position ).normalized() * 300
	elif flourishee.is_not_move:
		
		velocity += (global_position - flourishee.global_position ).normalized() * 300
	pass # Replace with function body.
