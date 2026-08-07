class_name Enemy extends CharacterBody2D
@onready var animsprite = $Sprite2D
@onready var enemy_fov = $enemy_fov
@onready var hitter = $hitter/CollisionShape2D
@onready var animfx = $AnimatedFX
@onready var state_machine : EnemyStateMachine = $statemachine
@onready var g_timer  =  $general_timer
@onready var label  =  $Label
var stun_time : float = 0


var was_last_hit : float


var bodyIsee : Array[CharacterBody2D]
var player
var random_pt : Vector2 = Vector2.ZERO
var secondary_vel : Vector2   = Vector2.ZERO
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var last_hit_from: Vector2 = Vector2.ZERO

@export var hit_tol : int = 3
var hit_tol_max : int


@export var in_attk_type : Array[Color]
var  in_attk_type_copy : Array[Color]
@export var out_attk_time : Array[float] 
@export var out_attk_color : Array[Color] 
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
@export var puddle_color: Color = Color.RED
@export var health: int = 1
var enemy_color: Color

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

	label.text = str(health)
	in_attk_type_copy = in_attk_type
	hit_tol_max = hit_tol
	state_machine.init()
	enemy_color = puddle_color
	#direction.y = 1
	pass # Replace with function body.

func Process(delta: float) -> void:
	
	
	was_last_hit += delta
	
	stun_time = move_toward(stun_time,0,delta)
	is_not_move = pos_check(delta)
	if player != null and chase == true:
		hitter.get_parent().look_at(player.position)
		chase_dir = (player.position-position + random_pt).normalized()
	
	if velocity.length() > 0:
		enemy_fov.position = velocity.normalized()*70
		enemy_fov.rotation =  (velocity).angle()
	boids()
	
func _physics_process(delta: float) -> void:

	
	move_and_slide()
	
	

func UpdateAnimation(state : String) -> void:
	#animation_player.play(state + "_" + AnimDirect())
	pass
	
func increment_in_attk_type(color : Color):
	if in_attk_index < 7:
		print(color,"color measure1")
		print(in_attk_type[in_attk_index],"color measure2")
		print(RythmLoader.measure_similiar_color(color,in_attk_type[in_attk_index]), " measure")
		if RythmLoader.measure_similiar_color(color,in_attk_type[in_attk_index]) <= 1.31 and RythmLoader.check_similiar_colour(color,in_attk_type[in_attk_index]) :
			in_attk_type[in_attk_index+1] = RythmLoader.minus_color(in_attk_type[in_attk_index],color,true)
			animfx.modulate =  in_attk_type[in_attk_index+1]
			animfx.play("shine1")
			in_attk_index += 1

		elif RythmLoader.check_similiar_colour(color,in_attk_type[in_attk_index]):
			
			animfx.modulate =  in_attk_type[in_attk_index+1]
			animfx.play("shine1")
			in_attk_index += 1

		else:
			in_attk_index = 99
			in_attk_type = in_attk_type_copy
			animfx.modulate = Color.WHITE
			animfx.play("default")
	else:
		
		if in_attk_index != 99:
			in_attk_index = 99
			in_attk_type = in_attk_type_copy
			animfx.modulate = Color.WHITE
			animfx.play("default")
		else:
			in_attk_index = randi_range(0,7)
			animfx.modulate =  in_attk_type[in_attk_index]
			animfx.play("shine1")
	#print("most recent ",animfx.modulate, in_attk_index)

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
			



func damage(color : Color,amount: int, from: Vector2 = Vector2.ZERO) -> void:
	if was_last_hit >= 0.15:
		was_last_hit = 0
		
		increment_in_attk_type(color )
		health -= amount
		label.text = str(health)
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
		
		


		
func parried( from : Player ,pwer : float = 1,_stun_time : float = 1):
	if player == null:
		player= from
	if stun_time <= 0 and stun_time > -0.01:
		hit_tol -= 1
		if hit_tol <= 0 and state_machine.curr_state is not enemy_attack:
			stun_time = _stun_time
			hit_tol = hit_tol_max
		else:
			stun_time = 0.3
	state_machine.stun_state.away_pwr = pwer
	
	var vel : Vector2 =  ( randi_range(-1,1)*secondary_vel.normalized()/2 + from.velocity.normalized()).normalized() *600 
	if from.velocity.length() == 0:
		vel =  ( randi_range(-1,1)*secondary_vel.normalized()/2 + from.last_dir.normalized()).normalized() *600 
	if velocity.length() <= 450:
		g_timer.start(0.05)
		await g_timer.timeout
	

		velocity = vel * pwer

	
	


	
func pos_check(_delta : float)-> bool:
	time_inter_pos += _delta
	if time_inter_pos < 0.05:
		inter_pos = global_position
	else:
		time_inter_pos = 0
	return (inter_pos == global_position and velocity.length() > 0)
	


func _on_hitter_body_entered(body: Player) -> void:
	if body.missed:
		print("fruhh")
		body.damage(self, true, 400)
		body.missed = false
	g_timer.start(0.2)
	await g_timer.timeout
	hitter.disabled = true

	
	animsprite.play("default")
#	pass # Replace with function body.
