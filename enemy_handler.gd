extends Node
var prev_time : float = 0
var enemies : Array[Enemy]
var max_process_interval : float = .05
var timer : float = 0
var index : int = 0
func get_enemy(enemy : Enemy):
	enemies.append(enemy)

func clear():
	prev_time = 0
	enemies = []
	
func _process(delta: float) -> void:
	timer += delta
	if timer >= min(max_process_interval,(5*max_process_interval/enemies.size())):
		for i in range(0,4):
			
			if index < enemies.size():
				if enemies[index] != null:
					enemies[index].Process(prev_time+delta)
					enemies[index].state_machine.Process(prev_time+delta)
					print(prev_time,"prev_time")
				index += 1
				
			else:
				index = 0

				break

		if prev_time < max_process_interval:
			prev_time += timer
		else:
			prev_time = max_process_interval
		timer = 0
