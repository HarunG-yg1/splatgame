extends Node2D
 
 
const BULLET = preload("res://Misc/bullet.tscn")
 

@onready var muzzle: Marker2D = $Marker2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var raycast2: RayCast2D = $RayCast2D2
@onready var raycast3: RayCast2D = $RayCast2D3
@onready var player = get_parent()
@export var gun_range: float = 1800.0
@export var fire_cooldown: float = 0.1
signal last_colided(colided:Enemy)
signal ammo_changed(current: int, max: int)
var raycast_group : Array [RayCast2D]


@export var max_ammo: int = 6

var can_fire: bool = true
var current_ammo: int = max_ammo
var aiming: bool = false

func _ready() -> void:
	raycast_group.append(raycast)
	raycast_group.append(raycast2)
	raycast_group.append(raycast3)
	
	raycast.target_position = Vector2(gun_range, -8)
	raycast2.target_position = Vector2(gun_range, 0)
	raycast3.target_position = Vector2(gun_range, 8)
	raycast.position = Vector2(0, -4)
	raycast2.position = Vector2(0, 0)
	raycast3.position = Vector2(0, 4)

	current_ammo = max_ammo
	ammo_changed.emit(current_ammo, max_ammo)

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
 
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
 
	if Input.is_action_just_pressed("shoot") and can_fire and player.stun <= 0:
		start_aiming()
		
	if Input.is_action_just_released("shoot"):
		stop_aiming()

func start_aiming() -> void:
	aiming = true
	player.sprite.play("AimShoot")

func stop_aiming() -> void:
	if aiming:
		aiming = false
		visible = false
		if can_fire and current_ammo > 0 and player.stun <= 0:
			shoot()
		player.sprite.play("idle")

func shoot() -> void:
		can_fire = false
		current_ammo -= 1
		ammo_changed.emit(current_ammo, max_ammo)
	
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation

		raycast.force_raycast_update()
		print("Gun Fired. Colliding: ", raycast.is_colliding())
		for Iraycast in raycast_group:
			if Iraycast.is_colliding():
				if (Iraycast.get_collider()) is Enemy:
					last_colided.emit(Iraycast.get_collider())
				var hit_object = Iraycast.get_collider()
				var hit_point = Iraycast.get_collision_point()
				print("Hit object: ", hit_object.name)
				print("Hit point: ", hit_point)
				break
			#if hit_object.has_method("damage"):
			#	hit_object.damage(9999, global_position)
			
			#if hit_object.has_method("parried"):
			#	hit_object.parried(hit_point)
			else:
				print("No collision — reached max range")
				
		await get_tree().create_timer(fire_cooldown).timeout
		can_fire = true

func reload(amount: int = -1) -> void:
	if amount < 0:
		current_ammo = max_ammo
	else:
		current_ammo = min(current_ammo + amount, max_ammo)
	ammo_changed.emit(current_ammo, max_ammo)
