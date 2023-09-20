@icon("res://NbFSM/icons/nbstate.svg")
class_name NbState 
extends NbSimpleFSM

signal state_entered()
signal state_exited()
signal state_physics_process(delta)
signal state_process(delta)
signal state_input(event)

var _transitions: Array[NbTransition] = []

func _ready():
	for child in get_children():
		if child is NbTransition:
			if not child.target_state:
				printerr("State " + self.name + ": Missing target state for transition " + child.name)
			_transitions.append(child)


func _get_transition(target: NbState) -> Array:
	for transition in _transitions:
		if transition.target_state == target:
			return [OK, transition.transition_delay, transition.broadcast_state]
	return [ERR_UNCONFIGURED]


func state_enter():
	@warning_ignore("return_value_discarded")
	emit_signal("state_entered")
	
func state_exit():
	@warning_ignore("return_value_discarded")
	emit_signal("state_exited")
	
func physic_processing(delta):
	@warning_ignore("return_value_discarded")
	emit_signal("state_physics_process", delta)
	
func processing(delta):
	@warning_ignore("return_value_discarded")
	emit_signal("state_process", delta)
	
func input(event):
	@warning_ignore("return_value_discarded")
	emit_signal("state_input", event)
