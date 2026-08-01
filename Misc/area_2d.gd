class_name blood_puddle extends Area2D

#enum puddle_colors {NO_COLOR,GREEN,BLUE,RED}
@export  var color_hex : Color = Color(1,1,1,1)
#@export var puddle_val : puddle_colors = puddle_colors.RED

var velocity: Vector2 = Vector2.ZERO
@export var friction: float = 400.0



func init(color_val : Color):
	$Timer.start(10)
	color_hex = color_val
	modulate = color_hex


func launch(initial_velocity: Vector2) -> void:
	velocity = initial_velocity

func _physics_process(delta: float) -> void:
	if velocity.length() > 1.0:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		position += velocity * delta

func _on_body_entered(body: Player) -> void:
	body.check_puddle(color_hex,self)
	pass # Replace with function body.


func _on_body_exited(body: Player) -> void:
	body.exit_puddle(self)

	pass # Replace with function body.



func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
