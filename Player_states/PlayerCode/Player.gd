class_name Player
extends CharacterBody2D
var para_in_sinwave : float
@onready var animfx = $animfx
@onready var sprite = $Sprite2D
@onready var statemachine = $statemachine
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D

@export var max_health: int = 10

var current_health: int = max_health
var i_time : float = 0
var blocking : bool = false
var stun : float = 0
var jumping : bool = false
var jump_vel : float = 0.0
var crouch : bool = false
var player_damage : int = 10
var dive_in : = false

var last_puddle : blood_puddle
var arr_of_blood : Array[int] = [0]

var was_attk_time  : float 
var run = false
var finish_run = true
const INITIAL_SPEED = 55.0
const MAX_SPEED = 320
var direction : Vector2
var curr_attker : Enemy = null

signal health_changed(current: int, max: int)

func _ready() -> void:
	statemachine.player = self
	statemachine.init()
	attack_shape.disabled = true
	


func _process(delta: float) -> void:
	
	attack_box.look_at(get_global_mouse_position())
	if i_time > 0:
		i_time -= delta
	if stun > 0:
		stun -= delta*2
	was_attk_time-=delta
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
	
	if Input.is_action_just_pressed("Attack"):
		attack()
		
	
	if Input.is_action_just_pressed("jump") and !jumping:
		#jump_vel = 0
		jumping = true
		jump()
	
	jump_and_fall(delta)
	
		
	if stun <= 0 || stun > 0.8:
		direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
	else:
		direction = Vector2.ZERO
func attack():
	attack_shape.disabled = false 
	await get_tree().create_timer(0.2).timeout
	attack_shape.disabled = true
	

func jump_and_fall(delta):
	if jumping:
		print(jump_vel)
		jump_vel += delta * 160
		para_in_sinwave += delta * 320 * 2

		#if para_in_sinwave <= 360:
			
		sprite.position.y += 20 * -(sin(deg_to_rad(para_in_sinwave)))*0.04

	if jump_vel >= 80:

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
	move_and_slide()
	
	


func _on_attack_box_body_entered(body: Enemy) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("damage"):
			body.parried(global_position)
			body.damage(player_damage)

func damage(amnt : int , from : Vector2, attker : Enemy, pwer : float, melee : bool):
	was_attk_time = 0.5
	curr_attker = attker
	if i_time <= 0 and stun <= 0:
		stun = 1
		current_health -= amnt
		health_changed.emit(current_health, max_health)
		if current_health <= 0:
			die()
		if !melee:
			velocity -=  (from - global_position).normalized() * pwer
	if melee:
		velocity -=  (from - global_position).normalized() * pwer
	pass

func die() -> void:
	print("Player died")


func check_puddle(puddle_val : int, this_puddle : blood_puddle):
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
		arr_of_blood.pop_front()
		visible = true
		last_puddle = null
		dive_in = false
	pass
	
