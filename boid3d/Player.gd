extends Node3D

var NEIGHBOR_DISTANCE = 20.0
var SEPARATION_DISTANCE = 6.0

# How fast the player moves in meters per second.
var INITIAL_SPEED = 4.0
var MIN_SPEED = 3.0
var MAX_SPEED = 8.0
var MAX_FORCE = 0.35

var KEEP_TOGETHER_WEIGHT = 0.8
var AVERAGE_VELOCITY_WEIGHT = 1.1
var MOVE_AWAY_WEIGHT = 1.6
var BOUNDARY_WEIGHT = 1.2
var WANDER_WEIGHT = 0.08

var AREA_SIZE = 25
var BOUNDARY_MARGIN = 8.0

var velocity = Vector3.ZERO
var _wander_heading = Vector3.ZERO

func _ready():
	add_to_group("boid")
#	var _timer = Timer.new()
#	add_child(_timer)
#	_timer.connect("timeout", self, "recalculate_velocity")
#	_timer.set_wait_time(randf()*100)
#	_timer.set_one_shot(false) # Make sure it loops
#	_timer.start()
	randomize_velocity()
	_wander_heading = velocity.normalized()
	
func randomize_velocity():
	velocity.x=(randf()-0.5)*INITIAL_SPEED
	velocity.y=(randf()-0.5)*INITIAL_SPEED
	velocity.z=(randf()-0.5)*INITIAL_SPEED
	if velocity.length() < MIN_SPEED:
		velocity = Vector3.FORWARD.rotated(Vector3.UP, randf() * TAU).rotated(Vector3.RIGHT, (randf() - 0.5) * PI) * MIN_SPEED

func _physics_process(delta):
	if velocity != Vector3.ZERO:
		$Pivot.look_at(position + velocity.normalized(), Vector3.UP)

	self.transform.origin += velocity * delta

	recalculate_velocity(delta)

func recalculate_velocity(delta):
	var count=0
	var keep_together=Vector3.ZERO
	var move_away=Vector3.ZERO
	var average_velocity=Vector3.ZERO
	var main = get_parent()
	var neighbors = main.get_neighbors(self.transform.origin, NEIGHBOR_DISTANCE)

	for child in neighbors:
		if child == self:
			continue
		var neighbor_distance = child.transform.origin.distance_to(self.transform.origin)
		if(neighbor_distance<NEIGHBOR_DISTANCE):
			count+=1
			keep_together+=child.transform.origin
			if neighbor_distance < SEPARATION_DISTANCE and neighbor_distance > 0.001:
				move_away += (self.transform.origin - child.transform.origin).normalized() * ((SEPARATION_DISTANCE - neighbor_distance) / SEPARATION_DISTANCE)
			average_velocity+=child.velocity

	var steering = Vector3.ZERO
	if count>0:
		keep_together=keep_together/count
		keep_together=(keep_together-self.transform.origin).normalized()

		average_velocity/=count
		average_velocity=(average_velocity.normalized() - self.velocity.normalized())

		steering += keep_together * KEEP_TOGETHER_WEIGHT
		steering += move_away * MOVE_AWAY_WEIGHT
		steering += average_velocity * AVERAGE_VELOCITY_WEIGHT

	steering += _get_boundary_steering()
	steering += _get_wander_steering(delta)

	if steering.length() > MAX_FORCE:
		steering = steering.normalized() * MAX_FORCE

	self.velocity += steering * delta * 60.0

	if self.velocity.length() > MAX_SPEED:
		self.velocity=self.velocity.normalized() * MAX_SPEED
	elif self.velocity.length() < MIN_SPEED:
		self.velocity=self.velocity.normalized() * MIN_SPEED


func _get_boundary_steering():
	var position = self.transform.origin
	var desired = Vector3.ZERO

	if position.x < -AREA_SIZE + BOUNDARY_MARGIN:
		desired.x += 1.0
	elif position.x > AREA_SIZE - BOUNDARY_MARGIN:
		desired.x -= 1.0

	if position.y < -AREA_SIZE + BOUNDARY_MARGIN:
		desired.y += 1.0
	elif position.y > AREA_SIZE - BOUNDARY_MARGIN:
		desired.y -= 1.0

	if position.z < -AREA_SIZE + BOUNDARY_MARGIN:
		desired.z += 1.0
	elif position.z > AREA_SIZE - BOUNDARY_MARGIN:
		desired.z -= 1.0

	if desired == Vector3.ZERO:
		return Vector3.ZERO

	return desired.normalized() * BOUNDARY_WEIGHT


func _get_wander_steering(delta):
	var random_offset = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5) * delta * 2.0
	_wander_heading = (_wander_heading + random_offset).normalized()
	return _wander_heading * WANDER_WEIGHT
