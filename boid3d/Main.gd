extends Node

@export var player_scene: PackedScene
@export var boid_count: int = 500
@export var spawn_range: float = 25.0
@export var neighbor_cell_size: float = 20.0

var _spatial_hash := {}

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


func _physics_process(_delta):
	_rebuild_spatial_hash()
 
func spawn_player():
	var player = player_scene.instantiate()
	player.transform.origin = Vector3(
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range,
		randf() * spawn_range * 2.0 - spawn_range
	)
	add_child(player)


func get_neighbors(origin: Vector3, radius: float):
	var nearby := []
	var radius_cells = int(ceil(radius / neighbor_cell_size))
	var center = _to_cell(origin)

	for x in range(center.x - radius_cells, center.x + radius_cells + 1):
		for y in range(center.y - radius_cells, center.y + radius_cells + 1):
			for z in range(center.z - radius_cells, center.z + radius_cells + 1):
				var key = "%s:%s:%s" % [x, y, z]
				if _spatial_hash.has(key):
					nearby.append_array(_spatial_hash[key])

	return nearby


func _rebuild_spatial_hash():
	_spatial_hash.clear()
	for boid in get_tree().get_nodes_in_group("boid"):
		var key = _to_cell_key(boid.global_transform.origin)
		if !_spatial_hash.has(key):
			_spatial_hash[key] = []
		_spatial_hash[key].append(boid)


func _to_cell(position: Vector3):
	return Vector3i(
		int(floor(position.x / neighbor_cell_size)),
		int(floor(position.y / neighbor_cell_size)),
		int(floor(position.z / neighbor_cell_size))
	)


func _to_cell_key(position: Vector3):
	var cell = _to_cell(position)
	return "%s:%s:%s" % [cell.x, cell.y, cell.z]
