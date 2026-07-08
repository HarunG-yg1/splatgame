extends Button # dialogue options
signal item_pos(item_index:int,item_goto_index:int)
@export var item_goto_index:int = 0
@export var item_index:int = 0


func _on_pressed() -> void:
	item_pos.emit(item_index,item_goto_index)
	pass # Replace with function body.
