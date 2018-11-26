extends KinematicBody2D

const DEADZONE = 0.3

var move_speed = 150
var ctrl_nr = -1

func _ready():
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	#var velocity = Vector2(0, 0)
	
	if (ctrl_nr >= 0):
		var x_axis = Input.get_joy_axis(ctrl_nr, JOY_ANALOG_LX)
		var y_axis = Input.get_joy_axis(ctrl_nr, JOY_ANALOG_LY)
		
		var velocity = Vector2(x_axis, y_axis)
	
		if velocity.length() > DEADZONE:
			move_and_slide(velocity * move_speed)
	
		#if velocity.length() < DEADZONE:
		#	velocity = Vector2(0, 0)
		#else:
		#	velocity = move_and_slide(velocity * move_speed)
