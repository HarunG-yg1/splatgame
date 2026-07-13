class_name Enemy extends CharacterBody2D
@onready var animsprite = $Sprite2D
@onready var enemy_fov = $enemy_fov
@onready var hitter = $hitter/CollisionShape2D
@onready var animfx = $AnimatedFX
@onready var state_machine  = $statemachine
@onready var g_timer  =  $general_timer
var stun : float = 0

var bodyIsee : Array[CharacterBody2D]
var player
var random_pt : Vector2 = Vector2.ZERO
var secondary_vel : Vector2   = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_hit_from: Vector2 = Vector2.ZERO

@export var in_attk_type : Array[blood_puddle.puddle_colors]
@export var out_attk_time : Array[float] 
@export var out_attk_color : Array[blood_puddle.puddle_colors] 
var in_attk_index : int = 99

var time_inter_pos := 0.0
var is_not_move : = true
var inter_pos := Vector2.ZERO

const SPEED = 300.0
var chase_dir : Vector2
var chase : bool = false 

const BLOOD_PUDDLE = preload("res://puddle.tscn")

@export var damage_amnt : int = 1
@export var blood_count: int = 6
@export var blood_speed: float = 300.0
@export var blood_spread_degrees: float = 40.0
@export var puddle_color: blood_puddle.puddle_colors = blood_puddle.puddle_colors.RED
@export var health: int = 1
var enemy_color: blood_puddle.puddle_colors 

func die() -> void:
	visible = false
	player = Statloader.player
	RythmLoader.interrupt(self)
	if player != null:
		player.curr_out_attked = null
		player.gun.reload(blood_count)
		player.arr_of_blood.append(enemy_color)
		print("Added color: ", enemy_color, " | Array now: ", player.arr_of_blood)
	else:
		print("Enemy died but player reference was null — color not added")
	spawn_blood()
	g_timer.start(0.2)
	await g_timer.timeout
	call_deferred("queue_free")

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
	enemy_color = puddle_color
	#direction.y = 1
	pass # Replace with function body.

func _process(delta: float) -> void:
	if stun < -0.05:
		stun += delta
	elif  stun < 0 and stun >= -0.05:
		stun = 0
	is_not_move = pos_check(delta)
	if player != null and chase == true:
		hitter.get_parent().look_at(player.position)
		chase_dir = (player.position-position + random_pt).normalized()
	
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
		
		


		
func parried( from : Player ,pwer : float = 1,stun_time : float = 1):

	if stun <= 0 and stun > -0.01:
		stun = stun_time
	if from.velocity.length() > 0:
		velocity = (from.velocity) * 1.2
	else:
		velocity = (from.global_position-global_position).normalized()* max(from.velocity.length(),400)* pwer
		
	pass
	
func pos_check(_delta : float)-> bool:
	time_inter_pos += _delta
	if time_inter_pos < 0.02:
		inter_pos = global_position
	else:
		time_inter_pos = 0
	return (inter_pos == global_position and velocity.length() > 0)
	


func _on_hitter_body_entered(body: Player) -> void:
	if body.missed:
		print("fruhh")
		body.damage(self, true, 100)
		body.missed = false
	g_timer.start(0.2)
	await g_timer.timeout
	hitter.disabled = true

	
	animsprite.play("default")
#	pass # Replace with function body.
