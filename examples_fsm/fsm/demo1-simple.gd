extends Control

var state: String = "Off"


func _on_button_on_button_up():
	$NbChart/NbFSM.transition($NbChart/NbFSM/StateOn)


func _on_button_off_button_up():
	$NbChart/NbFSM.transition($NbChart/NbFSM/StateOff)


func _on_state_off_state_entered():
	set_state_label("Off")


func _on_state_on_state_entered():
	set_state_label("On")


func set_state_label(new_state: String):
	state = new_state
	$StateLabel.set_text("State is: " + state)
