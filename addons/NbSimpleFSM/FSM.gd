@icon("./icons/nbfsm.svg")
class_name NbFSM
extends NbSimpleFSM

@export var initial_state: NbState = null

var current_state: NbState = null
var timed_target: NbState = null
var timed_broadcast: NbState = null
var _chart: NbChart = null ## For error reporting

var TimerNode: Timer = Timer.new()

enum BlobDataType {
	ERROR = 0,
	DELAY = 1,
	BROADCAST = 2
}

func _ready():
	var parent = get_parent()
	if parent is NbChart:
		_chart = parent
	current_state = initial_state
	TimerNode.one_shot = true
	@warning_ignore("return_value_discarded")
	TimerNode.connect("timeout", Callable(self, "_timer_timeout"))
	add_child(TimerNode)

func physics_process(delta):
	if current_state:
		current_state.physic_processing(delta)

func process(delta):
	if current_state:
		current_state.processing(delta)

func transition(target: NbState, disable_broadcast = false):
	state_change(target, disable_broadcast)

func state_change(target: NbState, disable_broadcast = false):
	if current_state.name == target.name:
		return
	
	var blob = current_state._get_transition(target)
	
	if blob[BlobDataType.ERROR] == OK:
		var wait_time = blob[BlobDataType.DELAY]
		var broadcast = blob[BlobDataType.BROADCAST]
		if wait_time <= 0.0:
			#direct
			_transition(target)
			if not disable_broadcast and broadcast:
				_broadcast(broadcast)
		else:
			timed_target = target
			if not disable_broadcast and broadcast:
				timed_broadcast = broadcast
			TimerNode.wait_time = wait_time
			TimerNode.start()
			
			
	else:
		if _chart:
			_chart.error(self.name + ": Invalid state transition: " + current_state.name + " -> " + target.name)


func _transition(target: NbState):
	current_state.state_exit()
	current_state = target
	current_state.state_enter()

func _broadcast(target: NbState):
	var parent = target.get_parent()
	if parent is NbFSM:
		parent.state_change(target, true)
	else:
		if _chart:
			_chart.error(self.name + ": Parent of " + target.name + " is not of type NbFSM")

func _timer_timeout():
	_transition(timed_target)
	if timed_broadcast:
		_broadcast(timed_broadcast)
		timed_broadcast = null
	timed_target = null
