extends Area2D #dialogue area
#class_name DialogueBranch

signal option_pressed




@export var dialogue: dialogue_lines

@onready var dialogue_options = $CanvasLayer/DialogueOptions
@onready var option1 = $CanvasLayer/DialogueOptions/Option1

var do_event_dict : Dictionary

var player = null
#var event_indexs : Array[int_arr_str] 

var dialog_branch : Array 
var is_chatting : bool = false

												#first arr is the type of func to execute n value is the filepath to it
												# The array should be the same size as the options available at line options at that option position
												#The result of the dialogue options can go to existing dialogue line if needed

var lines_array:Array 




func _ready():
	monitoring = true
	
	
	
	lines_array = dialogue.get_lines() 
	dialog_branch = dialogue.get_lines_option()
	
	Dialogue.finish_lines.connect(next_line)
	#await Dialogue.finish_lines.connect(next_line)
	#dialogue.get_stuff(self)



func next_line():
	for key in do_event_dict:
		call(key,do_event_dict[key])

	if  dialog_branch.size() > 0 and dialogue.option_position[dialogue.index] < dialog_branch.size() and player != null:# and dialogue.option_position[dialogue.index] < dialog_branch.size():
		print(dialogue.index)
		print(dialog_branch.size())
		
		dialogue_options.show()
		option1.text = dialog_branch[dialogue.option_position[dialogue.index]][0].string
		option1.item_goto_index = dialog_branch[dialogue.option_position[dialogue.index]][0].number
		option1.item_index = 0
		dialogue_options.get_child(0).item_pos.connect(item_pressed)
		for i in range(dialog_branch[dialogue.option_position[dialogue.index]].size()-1):
			var new_button = option1.duplicate()
			new_button.text = dialog_branch[dialogue.option_position[dialogue.index]][i+1].string
			new_button.item_goto_index =  dialog_branch[dialogue.option_position[dialogue.index]][i+1].number
			new_button.item_index  = i+1
			if dialogue_options.get_child(i+1) == null:
				dialogue_options.add_child(new_button)
				dialogue_options.get_child(i+1).item_pos.connect(item_pressed)
	
		
func item_pressed(item_index:int,item_goto_index:int):

	for i in range(dialog_branch[dialogue.option_position[dialogue.index]].size()-1):
		dialogue_options.remove_child(dialogue_options.get_child(dialogue_options.get_children().size()-1))
	#var event_find = dialogue.eventIndexs_find_ias(dialogue.index)
	
	do_event_dict = dialog_branch[dialogue.option_position[dialogue.index]][item_index].events_n_args
	
	
		#da_stat_dict = event_find.stat_dict

			
	dialogue.index = item_goto_index
	option_pressed.emit()
	
	Dialogue.start_dialog(get_child(0), lines_array[dialogue.index])
	dialogue_options.hide()
	
	
		
		
func _on_body_entered(body: Player) -> void:
	if !is_chatting:
		print("toto")
		Dialogue.start_dialog(get_child(0), lines_array[dialogue.index])
		is_chatting = true
		player = body
		print(player)


func _on_body_exited(body: Player) -> void:
	if body == player and exit_area:
		dialogue_options.hide()
		if is_chatting and Dialogue.is_dialog_active == true:
			Dialogue.text_box.queue_free()
			Dialogue.is_dialog_active = false
			
			Dialogue.current_line_index = 0
		
		dialogue.index = 0
		
		is_chatting = false
		player = null


		
