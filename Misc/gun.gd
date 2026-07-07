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
var raycast_group : Array [RayCast2D]
var can_fire: bool = true

func _ready() -> void:
	raycast_group.append(raycast)
	raycast_group.append(raycast2)
	raycast_group.append(raycast3)
	
	raycast.target_position = Vector2(gun_range, -4)
	raycast2.target_position = Vector2(gun_range, 0)
	raycast3.target_position = Vector2(gun_range, 4)
	raycast.position = Vector2(0, -4)
	raycast2.position = Vector2(0, 0)
	raycast3.position = Vector2(0, 4)

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
 
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
 
	if Input.is_action_just_pressed("shoot") and can_fire and player.stun <= 0:
		shoot()
		
func shoot() -> void:
		can_fire = false
	
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = muzzle.global_position
		bullet_instance.rotation = rotation

		raycast.force_raycast_update()
		print("Gun Fired. Colliding: ", raycast.is_colliding())
		for Iraycast in raycast_group:
			if Iraycast.is_colliding():
				if (Iraycast.get_collider()) is Enemy:
					last_colided.emit(raycast.get_collider())
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
