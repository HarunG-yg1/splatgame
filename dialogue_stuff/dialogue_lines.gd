extends Resource
class_name dialogue_lines
var index : int



@export var lines0: Array[String]
@export var lines1: Array[String]
@export var lines2: Array[String]
@export var lines3: Array[String]
@export var lines4: Array[String]
@export var lines5: Array[String]
@export var lines6: Array[String]
@export var lines7: Array[String]
@export var lines8: Array[String]
@export var lines9: Array[String]

@export var option_position: Array[int] = []

@export var line0Options : Array [str_int_pair]
@export var line1Options : Array [str_int_pair]
@export var line2Options : Array [str_int_pair]
@export var line3Options : Array [str_int_pair]
@export var line4Options : Array [str_int_pair]
@export var line5Options : Array [str_int_pair]
@export var line6Options : Array [str_int_pair]
@export var line7Options : Array [str_int_pair]
@export var line8Options : Array [str_int_pair]



func get_lines():
	var lines_array : Array = [lines0,lines1,lines2,lines3,lines4,lines5,lines6,lines7,lines8,lines9]
	var lines_array_new : Array
	for i in range(lines_array.size()):
		if lines_array[i].size() > 0:
			lines_array_new.append(lines_array[i]) 
		else:
			break
	return lines_array_new

func get_lines_option():
	var lines_array_option  : Array = [line0Options,line1Options,line2Options,line3Options,line4Options,line5Options,line6Options,line7Options,line8Options]
	var lines_array_option_new  : Array [Array]
	
	for i in range(lines_array_option.size()):
		var size:int = lines_array_option[i].size()
		
		if size!=0:
			lines_array_option_new.append(lines_array_option[i])
		else:
			break
	return lines_array_option_new
