@icon("res://NbFSM/icons/nbchart.svg")
class_name NbChart
extends NbSimpleFSM


var history: Array[String] = []

func error(error_msg: String):
	history.append(error_msg)
	printerr(error_msg)
