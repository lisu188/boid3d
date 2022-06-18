extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14

var velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_key_pressed(KEY_Z):
		direction.y += 1
	if Input.is_key_pressed(KEY_X):
		direction.y -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		# In the lines below, we turn the character when moving and make the animation play faster.
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.ONE)
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1

	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	velocity.z = direction.z * speed

	velocity = move_and_slide(velocity, Vector3.UP)
	
	is_on_ceiling()
	print(transform.origin)

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

