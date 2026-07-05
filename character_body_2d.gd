class_name Player
extends CharacterBody2D
var para_in_sinwave : float
@onready var sprite = $Sprite2D
@onready var statemachine = $statemachine
@onready var attack_box: Area2D = $AttackBox
@onready var attack_shape: CollisionShape2D = $AttackBox/CollisionShape2D



var jumping : bool = false
var jump_vel : float = 0.0
var crouch : bool = false
var player_damage : int = 10

var run = false
var finish_run = true
const INITIAL_SPEED = 55.0
const MAX_SPEED = 264.0
var direction : Vector2

func _ready() -> void:
	statemachine.player = self
	statemachine.init()
	attack_shape.disabled = true
	


func _process(delta: float) -> void:

	if Input.is_action_pressed("crouch"):
		crouch = true
	else:
		crouch = false 
	if Input.is_action_pressed("dash") and finish_run and !run and velocity.length()>1:
		run = true
		finish_run = false
		await get_tree().create_timer(1).timeout
		run = false
	
	if Input.is_action_just_pressed("Attack"):
		attack()
		
	
	if Input.is_action_just_pressed("jump") and !jumping:
		jumping = true
		jump()
	
	jump_and_fall(delta)
	
		
	
	direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()

func attack():
	attack_shape.disabled = false 
	await get_tree().create_timer(0.2).timeout
	attack_shape.disabled = true
	

func jump_and_fall(delta):
	if jumping:
		jump_vel += delta * 320
		para_in_sinwave += delta * 720

		if para_in_sinwave <= 360:
			
			sprite.position.y += 20 * -(sin(deg_to_rad(para_in_sinwave)))*0.06

	if jump_vel >= 80:

		jump_vel = 0
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

	


func _on_attack_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("damage"):
			body.damage(player_damage)
