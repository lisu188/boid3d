extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 10

var velocity = Vector3.ZERO
var target_velocity = Vector3.ZERO
var time_to_rotate = 10;

func _ready():
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "randomize_velocity")
	_timer.set_wait_time(randf()*100)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	randomize_velocity()
	
func randomize_velocity():
	target_velocity.x=(randf()-0.5)*speed
	target_velocity.y=(randf()-0.5)*speed
	target_velocity.z=(randf()-0.5)*speed
	
func _physics_process(delta):
	if velocity!=Vector3.ZERO:
		$Pivot.look_at(translation + velocity.normalized(), Vector3.ONE)

	velocity.x+=(target_velocity.x-velocity.x)*(delta/time_to_rotate)
	velocity.y+=(target_velocity.y-velocity.y)*(delta/time_to_rotate)
	velocity.z+=(target_velocity.z-velocity.z)*(delta/time_to_rotate)
	
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_PlayerDetector_body_entered(body):
	print("Weszło")


func _on_PlayerDetector_body_exited(body):
	print("Wyszło")


func _on_PlayerDetector_area_entered(area):
	print("Weszło")


func _on_PlayerDetector_area_exited(area):
	print("Wyszło")


func _on_PlayerDetector_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Weszło")


func _on_PlayerDetector_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	print("Wyszło")


func _on_PlayerDetector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Weszło")


func _on_PlayerDetector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	print("Wyszło")
