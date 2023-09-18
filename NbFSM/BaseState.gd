extends Node
class_name NbBaseState



var parent_machine: NbFSM = null

func _state_init():
	process_mode = Node.PROCESS_MODE_DISABLED

func _state_enter():
	pass

func _state_exit():
	pass

func physics_process(delta):
	pass

func process(delta):
	pass
