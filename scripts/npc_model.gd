extends Node3D

@export var face_target := Vector3(0, 0, 0)

func _ready() -> void:
	_face_target()

func _face_target() -> void:
	look_at(Vector3(face_target.x, global_position.y, face_target.z), Vector3.UP)
