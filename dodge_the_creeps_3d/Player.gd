extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 32

var velocity = Vector3.ZERO

func _ready():
	velocity.x=(randf()-0.5)*speed
	velocity.y=(randf()-0.5)*speed
	velocity.z=(randf()-0.5)*speed
	
func _physics_process(delta):
	$Pivot.look_at(translation + velocity.normalized(), Vector3.ONE)

	velocity = move_and_slide(velocity, Vector3.UP)
	
	# Here, we check if we landed on top of a mob and if so, we kill it and bounce.
	# With move_and_slide(), Godot makes the body move sometimes multiple times in a row to
	# smooth out the character's motion. So we have to loop over all collisions that may have
	# happened.
	# If there are no "slides" this frame, the loop below won't run.
	#for index in range(get_slide_count()):
	#	var collision = get_slide_collision(index)
	#	if collision.collider.is_in_group("mob"):
	#		var mob = collision.collider
	#		if Vector3.UP.dot(collision.normal) > 0.1:
	#			velocity.y = bounce_impulse
