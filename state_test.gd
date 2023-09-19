extends Node2D

var counterIdle = 0.0
var counterTest = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$NbChart/TestFSM.physics_process(delta)
	$NbChart/ParallelFSM.process(delta)


func _on_idle_state_entered():
	$Label.set_text("Current State: Idle")



func _on_idle_state_physic_processing(delta):
	counterIdle += delta
	$idleCounter.set_text("idle: " + str(counterIdle))
	


func _on_test_state_physic_processing(delta):
	counterTest += delta
	$testCounter.set_text("state a: " + str(counterTest))



func _on_btn_to_idle_button_up():
	$NbChart/TestFSM.state_change($NbChart/TestFSM/Idle)


func _on_btn_to_b_button_up():
	$NbChart/TestFSM.state_change($NbChart/TestFSM/StateB)


func _on_btn_to_a_button_up():
	$NbChart/TestFSM.state_change($NbChart/TestFSM/StateA)


func _on_off_state_entered():
	$Label3.set_text("Parallel: Off")


func _on_on_state_entered():
	$Label3.set_text("Parallel: On")


func _on_state_b_state_entered():
	$Label.set_text("Current State: B")


func _on_state_a_state_entered():
	$Label.set_text("Current State: A")
