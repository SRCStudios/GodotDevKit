extends Node

# PURPOSE : A TOPDOWN MOVEMENT CHARACTER FRAMEWORK
# PROCESS : 
# 			-> Take the direction of input
# 			-> Apply that to the velocity
# 			-> Move the player on the basis of the velocity



onready var body = get_parent().get_node("KinematicBody2D") # THE PHYSICS BODY
var graphics # THE PLAYER GRAPHICS

var velocity = Vector2.ZERO # THE VELOCITY
var accel    = 0 # ACCELERATION VALUE
var frict    = 0 # FRICTION VALUE
var axis     = Vector2.ZERO # INPUT DIRECTION

const FPS = 60 # THE FRAMES PER SECOND

export var max_speed    : float  # PLAYER'S SPEED
export var accel_frames : int    # FRAMES TILL MAX SPEED
export var frict_frames : int    # FRAMES TILL STOP
export var debug_mode   : bool   # DEBUGGING CHECKBOX

var is_debugging = false

func _ready():                # INITIALIZATION
	accel = max_speed / float(accel_frames)
	frict = max_speed / float(frict_frames)
	
	if get_parent().get_parent().get_node("Graphics"):
		graphics = get_parent().get_parent().get_node("Graphics")
	else:
		print("No Graphics")

func _physics_process(delta): # MOVEMENT_LOOP
	
	set_velocity(delta * FPS)
	
	if graphics:
		graphics.position = body.position
	
	
	if debug_mode == true and is_debugging == false:
		debug()

func set_velocity(dt):        # SET THE VELOCITY
	axis = set_input_dir()
	
	if axis == Vector2.ZERO:
		do_friction(frict * dt)
	else:
		do_movement(axis * accel * dt)
	velocity = body.move_and_slide(velocity)

func set_input_dir():         # SET THE INPUT DIRECTION
	var xd = 0
	var yd = 0
	xd = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	yd = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(xd, yd).normalized()

func do_movement(amount):     # APPLY MOVEMENT
	velocity += amount
	velocity = velocity.clamped(max_speed)

func do_friction(amount):     # APPLY FRICTION
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func debug():                 # DEBUGGING PURPOSES
	print("Acceleration = " + str(accel))
	print("Friction = "     + str(frict))
	print("Velocity = "     + str(velocity))
	print("Direction = "    + str(axis))
	print("--------------------------")
	is_debugging = true
	yield(get_tree().create_timer(1), "timeout")
	is_debugging = false
