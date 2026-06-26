extends Node3D

const HOUSE_SCENE := preload("res://scenes/house.tscn")

const PLACEMENTS := [
	{"pos": Vector3(-32, 0, -22), "rot": 0.0},
	{"pos": Vector3(28, 0, 24), "rot": -1.2},
	{"pos": Vector3(-26, 0, 32), "rot": 2.4},
	{"pos": Vector3(34, 0, -28), "rot": 0.8},
	{"pos": Vector3(-38, 0, 8), "rot": -0.5},
	{"pos": Vector3(8, 0, -38), "rot": 1.6},
]

func _ready() -> void:
	for data in PLACEMENTS:
		var house: Node3D = HOUSE_SCENE.instantiate()
		add_child(house)
		house.global_position = data.pos
		house.rotation.y = data.rot
