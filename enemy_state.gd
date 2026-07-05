class_name Enemy_State extends Node
##ref to what this state belongs to
var enemy : Enemy
var statemachine = EnemyStateMachine
func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#what happens when player enters state
func Enter() ->void:
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	return null
