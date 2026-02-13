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

var AREA_SIZE = 25

var velocity = Vector3.ZERO

func _ready():
#	var _timer = Timer.new()
#	add_child(_timer)
#	_timer.connect("timeout", self, "recalculate_velocity")
#	_timer.set_wait_time(randf()*100)
#	_timer.set_one_shot(false) # Make sure it loops
#	_timer.start()
	randomize_velocity()
	
func randomize_velocity():
	velocity.x=(randf()-0.5)*INITIAL_SPEED
	velocity.y=(randf()-0.5)*INITIAL_SPEED
	velocity.z=(randf()-0.5)*INITIAL_SPEED
	if velocity.length() < MIN_SPEED:
		velocity = velocity.normalized() * MIN_SPEED

func _physics_process(delta):
	if velocity!=Vector3.ZERO:
<<<<<<< Updated upstream
		$Pivot.look_at(translation + velocity.normalized(), Vector3.ONE)

	self.transform.origin += velocity * delta

	recalculate_velocity(delta)

=======
		$Pivot.look_at(position + velocity.normalized(), Vector3.ONE)
	
	self.transform.origin+=velocity;
	
	recalculate_velocity()
	
>>>>>>> Stashed changes
	bounce_off()
	
func bounce_off():
	if self.transform.origin.x<-AREA_SIZE:
		if self.velocity.x <0:
			self.velocity.x=-self.velocity.x
	if self.transform.origin.x>AREA_SIZE:
		if self.velocity.x >0 :
			self.velocity.x=-self.velocity.x
		
	if self.transform.origin.y<-AREA_SIZE:
		if self.velocity.y <0:
			self.velocity.y=-self.velocity.y
	if self.transform.origin.y>AREA_SIZE:
		if self.velocity.y >0 :
			self.velocity.y=-self.velocity.y
		
	if self.transform.origin.z<-AREA_SIZE:
		if self.velocity.z<0:
			self.velocity.z =-self.velocity.z
	if self.transform.origin.z>AREA_SIZE:
		if self.velocity.z >0 :
			self.velocity.z=-self.velocity.z
	

func recalculate_velocity(delta):
	var count=0
	var keep_together=Vector3.ZERO
	var move_away=Vector3.ZERO
	var average_velocity=Vector3.ZERO

	for child in get_parent().get_children():
		if child == self:
			continue
		if child.get_name().find("Player")!=-1:
			var neighbor_distance = child.transform.origin.distance_to(self.transform.origin)
			if(neighbor_distance<NEIGHBOR_DISTANCE):
				count+=1
				keep_together+=child.transform.origin
				if neighbor_distance < SEPARATION_DISTANCE and neighbor_distance > 0.001:
					move_away += (self.transform.origin - child.transform.origin).normalized() * ((SEPARATION_DISTANCE - neighbor_distance) / SEPARATION_DISTANCE)
				average_velocity+=child.velocity

	if count>0:
		keep_together=keep_together/count
		keep_together=(keep_together-self.transform.origin).normalized()

		average_velocity/=count
		average_velocity=(average_velocity.normalized() - self.velocity.normalized())

		var steering = keep_together * KEEP_TOGETHER_WEIGHT + move_away * MOVE_AWAY_WEIGHT + average_velocity * AVERAGE_VELOCITY_WEIGHT
		if steering.length() > MAX_FORCE:
			steering = steering.normalized() * MAX_FORCE

		self.velocity += steering * delta * 60.0

	if self.velocity.length() > MAX_SPEED:
		self.velocity=self.velocity.normalized() * MAX_SPEED
	elif self.velocity.length() < MIN_SPEED:
		self.velocity=self.velocity.normalized() * MIN_SPEED
