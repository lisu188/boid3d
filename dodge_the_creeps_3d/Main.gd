extends Node

export(PackedScene) var player_scene

func _ready():
	randomize()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
 
func _on_PlayerTimer_timeout():
	for i in 10:
		var player=player_scene.instance()
		var player_spawn_location = get_node("Player")
		var vector=Vector3()
		vector.x=i
		vector.y=i
		vector.z=i
		player.transform.origin =Vector3.ZERO + vector
		add_child(player)
