extends Node
#var daddy_node :CanvasLayer
var player : Player
var hitlineScene = preload("res://Misc/defense.tscn")
var  hitline : defense_box
func addTo_hitline(hit_arr : Array[float] , color_arr : Array[Color], hit_owner : Enemy):
	var acc : float = 0
	if hitline == null:
		_show_attack_box()
	for i : int in range(hit_arr.size()):
		if hit_arr[hit_arr.size() - i - 1]>= 0.0:
			
			acc += hit_arr[hit_arr.size() - i - 1]
			#var time = acc
			hitline.add( color_arr[hit_arr.size() - i - 1],acc,hit_owner)
		
	#	print(acc,"nroon")


func interrupt(hit_owner : Enemy):
	if hitline == null:
		_show_attack_box()
	hitline.remove(hit_owner)


func _show_attack_box():
	hitline = hitlineScene.instantiate()
	hitline.player = player
	player.add_child(hitline)

func find_attkType(type : Color)->bool:
	if hitline == null:
		_show_attack_box()
	return hitline.find_arrow_type(type)

func setHit_attkType(type : Color)->void:
	hitline.set_arrow_type(type)

func check_similiar_colour(color_in : Color, color_in2 : Color)-> bool:
	
	#print(check_light_level(color_in),"light lvl",color_in)
	#print(measure_similiar_color(Color.YELLOW,Color.ORANGE),"nurple")

	if (color_in == color_in2 || check_if_subarray(find_smallest_rgb(color_in) , find_smallest_rgb(color_in2)) || check_if_subarray(find_smallest_rgb(color_in2) , find_smallest_rgb(color_in))):
		
		return true
	return false
	
func measure_similiar_color(color_in : Color, color_in2 : Color)-> float:
	
	#print(check_light_level(color_in),"light lvl",color_in)
	var new_color : Color = add_color(color_in,color_in2)
	var vec_3_1 : Vector3 = Vector3(color_in.r,color_in.g,color_in.b)
	var vec_3_3 : Vector3 = Vector3(color_in2.r,color_in2.g,color_in2.b)
	var vec_3_2 : Vector3 = Vector3(new_color.r,new_color.g,new_color.b)
	
	
	var enabler : float =(vec_3_1.normalized() - Vector3(1,1,1).normalized()).length() * (vec_3_3.normalized() - Vector3(1,1,1).normalized()).length()
	if enabler > 0:
		enabler = 1
	return min(4,0.01 * round(enabler *100/( 0.1+ (vec_3_1.normalized() - vec_3_2.normalized()).length() + (vec_3_3.normalized() - vec_3_2.normalized()).length())))
	
func add_color(color_in : Color, color_in2 : Color)->Color:
	var color_arr_1 : Array[float] = [
	color_in.r + color_in2.r,
	color_in.g + color_in2.g,
	color_in.b +  color_in2.b,
	]
	
	var biggest : float = 0
	for i in color_arr_1:
		if biggest < i:
			biggest = i 
	for i : int in range(color_arr_1.size()):
		
		color_arr_1[i] /= biggest
		#if init >= 0.95:
		color_arr_1[i] **= 2

	return Color(color_arr_1[0],color_arr_1[1],color_arr_1[2],1)

func minus_color(color_in : Color, color_in2 : Color, biggest_to_one : bool = false)->Color:
	
	for  i : int in find_smallest_rgb(color_in):
		if i == 0:
			color_in.r = 0
		elif i == 1:
			color_in.g = 0
		elif i == 2:
			color_in.b = 0
	print(color_in,"color_in")
	for  i : int in find_smallest_rgb(color_in2):
		if i == 0:
			color_in2.r = 0
		elif i == 1:
			color_in2.g = 0
		elif i == 2:
			color_in2.b = 0
	print(color_in2,"color_in2")
	var color_arr_1 : Array[float] = [
	color_in.r - color_in2.r,
	color_in.g - color_in2.g,
	color_in.b -  color_in2.b,
	]
	var vec_3_1 : Vector3 = Vector3(color_in.r,color_in.g,color_in.b)
	var vec_3_2 : Vector3 = Vector3(color_in2.r,color_in2.g,color_in2.b)
	var biggest : float = 0
	
	if vec_3_1.normalized() == Vector3(1,1,1).normalized():
		return color_in2
	elif vec_3_2.normalized() == Vector3(1,1,1).normalized():
		return color_in

	for i : int in range(color_arr_1.size()):
		color_arr_1[i] = abs(color_arr_1[i])
		if color_arr_1[biggest] < color_arr_1[i]:
			biggest = i
		if color_arr_1[i] < 0.5:
			color_arr_1[i] = 0
		
			

	if biggest_to_one:

		for i : int in range(color_arr_1.size()):
			if color_arr_1[i] > 0:
				color_arr_1[i] /= color_arr_1[biggest]

	if color_arr_1[0] < 0.05 and color_arr_1[1]  < 0.05 and color_arr_1[2] < 0.05:
		color_arr_1[biggest] = 1

	return Color(color_arr_1[0],color_arr_1[1],color_arr_1[2],1)

	
func check_light_level(color_in : Color) -> int:
	var color_arr_1 : Array[float] = [color_in.r8,color_in.g8,color_in.b8]
	var acc : float
	var check_size : int = 0
	for i in color_arr_1:
		acc += i
		if i > 64:
			check_size += 1
	if check_size < 3:
		check_size += 1
	acc /= check_size
	if acc > 223:
		return 7
	elif acc > 191:
		return 6
	elif acc > 159:
		return 5
	elif acc > 127:
		return 4
	elif acc > 95:
		return 3
	elif acc > 63:
		return 2
	elif acc > 31:
		return 1
	else:
		return 0
	
func find_smallest_rgb(color : Color) ->Array[int]:
	var arr_1 : Array[float] = [color.r,color.g,color.b]
	var smallest : float = 1

	var small_arr : Array[int]
	for i in range(arr_1.size()):
		if smallest > arr_1[i]:
			smallest = arr_1[i]

	
	for i in range(arr_1.size()):
		if smallest == arr_1[i]:
			small_arr.append(i)
	if small_arr.size() >=3:
		return []
	return small_arr

func check_if_subarray(arr1 : Array ,arr2 : Array) -> bool:
	if arr1 == []:
		return false

	for i in arr1:
		if i not in arr2:
			return false
	return true
