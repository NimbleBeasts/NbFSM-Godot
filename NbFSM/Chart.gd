@icon("res://NbFSM/icons/state_chart.svg")
class_name NbChart
extends NbBaseState


# Features:
#  -[x] FSM
#  -[ ] Parallel states
#  -[ ] Animation sync
#  -[ ] Delay

var history: Array[String] = []

func error(error_string: String):
	history.append(error_string)
	printerr(error_string)
