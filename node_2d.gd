extends Node2D
@onready var boss1 = $MnR_Enemy
@onready var boss2 = $MnR_Enemy2
func _process(delta: float) -> void:
	if (boss1 == null and boss2 == null):
		$portal2.monitoring = true
		$dailogue_area.monitoring = true
		$portal2.set_collision_layer_value(2,true)
		$portal2.set_collision_mask_value(2,true)
		$dailogue_area.set_collision_layer_value(2,true)
		$dailogue_area.set_collision_mask_value(2,true)
		process_mode =Node.PROCESS_MODE_DISABLED
