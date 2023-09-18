@icon("res://NbFSM/icons/atomic_state.svg")
class_name NbState 
extends NbBaseState

signal state_entered()
signal state_exited()
signal state_physic_processing(delta)
signal state_processing(delta)
signal state_input(event)

var _transitions: Array[NbTransition] = []

func _ready():
	for child in get_children():
		if child is NbTransition:
			if not child.target_state:
				printerr("State " + self.name + ": Missing target state for transition " + child.name)
			_transitions.append(child)


func _state_change(target: NbState) -> Array:
	for transition in _transitions:
		if transition.target_state == target:
			return [OK, transition.transition_delay, transition.broadcast_state]
	return [ERR_UNCONFIGURED]


func state_enter():
	emit_signal("state_entered")
	
func state_exit():
	emit_signal("state_exited")
	
func physic_processing(delta):
	emit_signal("state_physic_processing", delta)
	
func processing(delta):
	emit_signal("state_processing", delta)
	
func input(event):
	emit_signal("state_input", event)
