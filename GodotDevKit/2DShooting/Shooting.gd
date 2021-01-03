extends Node

# TO MAKE THE WHOLE PLAYER ROTATE, MAKE THE ROOT INSTANCE THE CHILD OF ROOT NODE
# TO MAKE THE GUN ALONE ROTATE, MAKE THE TEST INSTANCE CHILD OF GRAPHICS OR REFERENCE IT SOMEHOW

var graphics

func _ready():
	if get_parent().get_parent().get_node("Graphics"):
		graphics = get_parent().get_parent().get_node("Graphics")

func _physics_process(delta):
	if graphics:
		var lookvec = get_parent().get_global_mouse_position() - graphics.global_position
		graphics.global_rotation = atan2(lookvec.y, lookvec.x)
