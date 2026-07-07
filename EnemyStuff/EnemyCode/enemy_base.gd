class_name Enemy extends CharacterBody2D
@onready var animsprite = $Sprite2D
@onready var enemy_fov = $enemy_fov

@onready var animfx = $AnimatedFX
@onready var state_machine  = $statemachine
@onready var hitter  = $the_hitter/CollisionShape2D
var stun : float = 0
var bodyIsee : Array[CharacterBody2D]
var player
var random_pt : Vector2 = Vector2.ZERO
var secondary_vel : Vector2   = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_hit_from: Vector2 = Vector2.ZERO

const SPEED = 150.0
var chase_dir : Vector2
var chase : bool = false 

const BLOOD_PUDDLE = preload("res://puddle.tscn")

@export var blood_count: int = 6
@export var blood_speed: float = 300.0
@export var blood_spread_degrees: float = 40.0
@export var puddle_color: blood_puddle.puddle_colors = blood_puddle.puddle_colors.RED
@export var health: int = 30
@export var enemy_color: int = 0

func die() -> void:
	spawn_blood()
	if player != null:
		player.arr_of_blood.append(enemy_color)
		print("Added color: ", enemy_color, " | Array now: ", player.arr_of_blood)
	else:
		print("Enemy died but player reference was null — color not added")
	queue_free()

func spawn_blood() -> void:
	var away_dir: Vector2

	if last_hit_from != Vector2.ZERO:
		away_dir = (global_position - last_hit_from).normalized()
	elif player != null:
		away_dir = (global_position - player.global_position).normalized()
	else:
		away_dir = Vector2.RIGHT.rotated(randf() * TAU)

	var puddle = BLOOD_PUDDLE.instantiate()
	get_tree().root.add_child(puddle)
	puddle.global_position = global_position
	puddle.init(puddle_color)
	puddle.launch(away_dir * blood_speed)

func _ready() -> void:

	state_machine.init()
	#direction.y = 1
	pass # Replace with function body.

func _process(delta: float) -> void:
	

	if player != null and chase == true:
		chase_dir = (player.position-position + random_pt).normalized()
		hitter.get_parent().look_at(player.position)
	if velocity.length() > 0:
		enemy_fov.position = velocity.normalized()*70
		enemy_fov.rotation =  (velocity).angle()
	pass
	
func _physics_process(delta: float) -> void:
	boids()
	
	move_and_slide()
	
	

func UpdateAnimation(state : String) -> void:
	#animation_player.play(state + "_" + AnimDirect())
	pass
	


func choose_randomly(list_of_entries):
	return list_of_entries[randi() % list_of_entries.size()]
	

func boids():
#	print( bodyIsee.size())
	var valid_bodies: Array[CharacterBody2D] = []
	var avgVel := Vector2.ZERO
	var avgPosition := Vector2.ZERO
	var steer_Away := Vector2.ZERO
	
	for body in bodyIsee:
		if is_instance_valid(body):
			valid_bodies.append(body)

	bodyIsee = valid_bodies
	var numOfbodies = bodyIsee.size()
	
	for body in bodyIsee:
		avgVel += body.velocity
		avgPosition += body.position
		steer_Away -= (body.global_position - global_position) *200/(body.global_position - global_position).length()

	if numOfbodies != 0:
		avgVel /=  numOfbodies
		if  !is_nan(avgVel.x):
			secondary_vel += (avgVel - secondary_vel)/2
		
		avgPosition /= numOfbodies 
		if  !is_nan(avgPosition.x):
			secondary_vel += (avgPosition- secondary_vel)
		
		steer_Away/=numOfbodies 
		if  !is_nan(steer_Away.x):
			secondary_vel += (steer_Away)
			
		#print("poofart")
		#print(secondary_vel,avgVel,avgPosition,steer_Away)
	

func damage(amount: int, from: Vector2 = Vector2.ZERO) -> void:
	health -= amount
	if from != Vector2.ZERO:
		last_hit_from = from
	if health <= 0:
		die()

func _on_enemy_fov_body_entered(body: CharacterBody2D) -> void:
	if body is Player   :
		chase = true
		player = body

	bodyIsee.append(body)


func _on_enemy_fov_body_exited(body: CharacterBody2D) -> void:
	if player == body and !chase:
		player = null
	if (body.global_position - global_position).length() > 80:
		bodyIsee.erase(body)
		
		


func _on_the_hitter_body_entered(body: Player) -> void:
	if body.has_method("damage"):
		body.damage(1,global_position, self, 200,true)
	
	await get_tree().create_timer(0.2).timeout
	hitter.disabled = true
	animsprite.play("default")
		
func parried( from : Vector2):
	print("sa parried")
	if stun <= 0:
		stun = 1
	velocity -=  (from - global_position).normalized() * 800
	pass
	
