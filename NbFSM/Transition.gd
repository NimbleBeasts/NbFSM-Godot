@icon("res://NbFSM/icons/transition.svg")
class_name NbTransition
extends NbBaseState


@export var target_state: NbState = null ## Target state of transition
@export var transition_delay: float = 0.0 ## Delay transition
@export var broadcast_state: NbState = null ## Broadcast transition state
