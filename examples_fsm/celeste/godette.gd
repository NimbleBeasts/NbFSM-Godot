extends CharacterBody2D


const MAX_SPEED: Vector2 = Vector2(450, 900)
const GRAVITY: float = 2100.0
const JUMP_HEIGHT: float = 36000.0
const ACCELERATION = 3000
const DASH_SPEED = Vector2(50000,50000)
const DASH_TIME_MAX = 10

const AGILITY_GROUND: float = 1.0
const AGILITY_AIR: float = 0.3


var input: Vector2 = Vector2.ZERO
var input_last: Vector2 = Vector2.ZERO


var can_jump: bool = false

var is_in_air: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var dash_time: float = 0

@onready var fsm: NbFSM = $NbChart/GodetteFSM
@onready var state_ground: NbState = $NbChart/GodetteFSM/ground
@onready var state_air: NbState = $NbChart/GodetteFSM/air
@onready var state_dash: NbState = $NbChart/GodetteFSM/dash
@onready var state_wall: NbState = $NbChart/GodetteFSM/wall
@onready var animationState = $AnimationTree.get("parameters/playback")


func _ready():
	Engine.time_scale = 1

func _physics_process(delta):
	# Get player input
	_get_input()


	# State processing
	fsm.physics_process(delta)
	
	# Apply gravity
	if velocity.y <= MAX_SPEED.y and not is_dashing:
		velocity.y += GRAVITY * delta

	# Direction
	if input.x < 0:
		$flip.scale.x = -1
	elif input.x > 0:
		$flip.scale.x = 1

	# Perform movement
	move_and_slide()


func _on_idle_state_physic_processing(delta):
	pass # Replace with function body.


func _get_input():
	if input != Vector2.ZERO:
		input_last = input
	input = Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)
	
	
	


func move(delta: float, agility: float):
	if input.x != 0:
		velocity.x = velocity.x + input.x * ACCELERATION * delta * agility
		
		velocity.x = max(min(velocity.x, MAX_SPEED.x), -MAX_SPEED.x)
		
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
	$Label.set_text(str(input) + "\n" + str(velocity))




func _on_jump_state_physic_processing(delta):
	if can_jump:
		velocity.y = -JUMP_HEIGHT * delta

func _on_walk_state_physic_processing(delta):
	velocity.x = (velocity.x + ACCELERATION * input.x * delta)




func _on_ground_state_physics_process(delta):
	if not is_on_floor():
		fsm.transition(state_air)

	move(delta, AGILITY_GROUND)
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_HEIGHT * delta
		animationState.travel("jump_pre")
		return

	if abs(velocity.x) > 10:
		animationState.travel("walk")
	elif is_in_air == false:
		animationState.travel("idle")
	

func _on_air_state_physics_process(delta):
	if is_on_floor():
		fsm.transition(state_ground)
		animationState.travel("jump_end")

	if Input.is_action_just_pressed("dash"):
		if can_dash and input_last != Vector2.ZERO:
			velocity = input_last.normalized() * DASH_SPEED * delta
			animationState.travel("dash")
			fsm.transition(state_dash)
			return

	move(delta, AGILITY_AIR)
	


func _on_dash_state_physics_process(delta):
	dash_time += 100 * delta
	
	if dash_time >= DASH_TIME_MAX:
		dash_time = 0
		fsm.transition(state_air)


func _on_wall_state_physics_process(delta):
	pass # Replace with function body.


func _on_air_state_entered():
	is_in_air = true


func _on_air_state_exited():
	is_in_air = false


func _on_ground_state_entered():
	can_dash = true


func _on_dash_state_entered():
	is_dashing = true


func _on_dash_state_exited():
	is_dashing = false
