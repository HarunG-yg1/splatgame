class_name blood_puddle extends Area2D

enum puddle_colors {RED,BLUE,GREEN}
@export var puddle_val : puddle_colors

var velocity: Vector2 = Vector2.ZERO
@export var friction: float = 400.0

func _ready() -> void:
	$Timer.start(20)
	match puddle_val:
		puddle_colors.RED:
			modulate = Color("red")
		puddle_colors.BLUE:
			modulate = Color("blue")
		puddle_colors.GREEN:
			modulate = Color("green")

func init(color_val : int):
	$Timer.start(20)
	puddle_val = color_val
	match color_val:
		puddle_colors.RED:
			modulate = Color("red")
		puddle_colors.BLUE:
			modulate = Color("blue")
		puddle_colors.GREEN:
			modulate = Color("green")

func launch(initial_velocity: Vector2) -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	if velocity.length() > 1.0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		position += velocity * delta

func _on_body_entered(body: Player) -> void:
	body.check_puddle(puddle_val,self)
	pass # Replace with function body.


func _on_body_exited(body: Player) -> void:
	body.exit_puddle(self)
	pass # Replace with function body.



func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
