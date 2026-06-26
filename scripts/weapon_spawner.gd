extends Node3D

const PICKUP_SCENE := preload("res://scenes/weapon_pickup.tscn")

const SPAWN_DATA := [
	{"id": "ak47", "pos": Vector3(-32, 0.8, -24)},
	{"id": "machinegun", "pos": Vector3(-30, 0.8, -20)},
	{"id": "pistol", "pos": Vector3(28, 0.8, 22)},
	{"id": "ak47", "pos": Vector3(30, 0.8, 26)},
	{"id": "machinegun", "pos": Vector3(-26, 0.8, 30)},
	{"id": "pistol", "pos": Vector3(-24, 0.8, 34)},
	{"id": "sniper", "pos": Vector3(34, 0.8, -30)},
	{"id": "rifle", "pos": Vector3(36, 0.8, -26)},
	{"id": "machinegun", "pos": Vector3(-38, 0.8, 6)},
	{"id": "ak47", "pos": Vector3(-36, 0.8, 10)},
	{"id": "pistol", "pos": Vector3(8, 0.8, -36)},
	{"id": "rifle", "pos": Vector3(12, 0.8, -38)},
	{"id": "sniper", "pos": Vector3(-20, 0.8, -15)},
	{"id": "pistol", "pos": Vector3(25, 0.8, -20)},
]

func _ready() -> void:
	for data in SPAWN_DATA:
		var pickup: Area3D = PICKUP_SCENE.instantiate()
		pickup.weapon_id = data.id
		add_child(pickup)
		if pickup.has_method("set_spawn_position"):
			pickup.set_spawn_position(data.pos)
		else:
			pickup.global_position = data.pos
