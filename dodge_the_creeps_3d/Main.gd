extends Node

export(PackedScene) var player_scene

func _ready():
	randomize()
	var _timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "spawn_player")
	_timer.set_wait_time(1)
	_timer.set_one_shot(false)
	_timer.start()
 
func spawn_player():
	var player=player_scene.instance()
	player.transform.origin = Vector3.ZERO #Vector3(randf()*100-50,randf()*100-50,randf()*100-50)
	add_child(player)
