extends Node

@export var player_scene: PackedScene
@export var boid_count: int = 500
@export var spawn_range: float = 25.0

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
	var player = player_scene.instantiate()
	player.transform.origin = Vector3(
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range
	)
	add_child(player)
