class_name hovering extends Enemy_State 
##ref to what this state belongs to
var hoverPos : Array[Vector2]

#what happens when player enters state
func Enter() ->void:
	pass
	
#what happens when player enters state
func Exit() ->void:
	pass
	
#what happens during process in state
func Process(_delta:float)->Enemy_State:
	
	return null
