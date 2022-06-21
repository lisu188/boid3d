extends Spatial

var DISTANCE=15

# How fast the player moves in meters per second.
var INITAL_SPEED = 0.1
var MAX_SPEED = 1

var KEEP_TOGETHER_WEIGHT=1/2
var AVERAGE_VELOCITY_WEIGHT=1/4
var MOVE_AWAY_WEIGHT=1/2

var AREA_SIZE=25

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
	velocity.x=(randf()-0.5)*INITAL_SPEED
	velocity.y=(randf()-0.5)*INITAL_SPEED
	velocity.z=(randf()-0.5)*INITAL_SPEED
	
func _physics_process(delta):
	if velocity!=Vector3.ZERO:
		$Pivot.look_at(translation + velocity.normalized(), Vector3.ONE)
	
	self.transform.origin+=velocity;
	
	recalculate_velocity()
	
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
	

func recalculate_velocity():
	var count=0
	var keep_together=Vector3.ZERO
	var move_away=Vector3.ZERO
	var average_velocity=Vector3.ZERO
	
	for child in get_parent().get_children():
		if child.get_name().find("Player")!=-1:
			if(child.transform.origin.distance_to(	self.transform.origin)<DISTANCE):
				count+=1
				keep_together+=child.transform.origin
				move_away+=self.transform.origin-child.transform.origin
				average_velocity+=child.velocity
	
	if count>0:
		keep_together=keep_together/count
		keep_together=keep_together-self.transform.origin
				
		average_velocity/=count
		average_velocity=average_velocity-self.velocity
		
		self.velocity=self.velocity+keep_together*KEEP_TOGETHER_WEIGHT+move_away*MOVE_AWAY_WEIGHT+average_velocity*AVERAGE_VELOCITY_WEIGHT
		if self.velocity.length() > MAX_SPEED:
			self.velocity=self.velocity/self.velocity.length() * MAX_SPEED
				

	
	
