class_name EnemyStateMachine
extends Node

var states : Array[Enemy_State] 
var curr_state : Enemy_State
var old_state : Enemy_State

@onready var enemy : Enemy =  $".."
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.

func init() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
func _ready() -> void:
	for i : Enemy_State in get_children():
		i.enemy = enemy
		i.statemachine = self
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
