extends Node

<<<<<<< Updated upstream
export(PackedScene) var player_scene
export(int) var boid_count = 500
export var spawn_range = 25.0
=======
@export var player_scene: PackedScene
>>>>>>> Stashed changes

func _ready():
	randomize()
#	var _timer = Timer.new()
#	add_child(_timer)
#	_timer.connect("timeout", self, "spawn_player")
#	_timer.set_wait_time(1)
#	_timer.set_one_shot(false)
#	_timer.start()
	for i in boid_count:
		spawn_player()
 
func spawn_player():
<<<<<<< Updated upstream
	var player=player_scene.instance()
	player.transform.origin = Vector3(
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range
	)
=======
	var player=player_scene.instantiate()
	player.transform.origin = Vector3(randf()*100-50,randf()*100-50,randf()*100-50)
>>>>>>> Stashed changes
	add_child(player)
