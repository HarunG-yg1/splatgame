class_name PlayerStateMachine
extends Node

var last_defend : blood_puddle.puddle_colors = blood_puddle.puddle_colors.NO_COLOR
var states : Array[state_class] 
var curr_state : state_class
var old_state : state_class

@onready var player =  $".."
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.

func init() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
func _ready() -> void:
	for i : state_class in get_children():
		
		i.guy1 = player
		i.statemachine = self
		i._init()
		states.push_back(i)
	curr_state = states[0]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state(curr_state.Process(delta))
	



func change_state(new_state):
	
	if new_state == null || new_state == curr_state:
		return
	old_state = curr_state
	curr_state.Exit()

	curr_state = new_state
	new_state.Enter()












	
