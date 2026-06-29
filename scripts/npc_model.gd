extends Node3D

const BODY_TEXTURE := "res://assets/npc/steve_reference_fullbody.png"
const FALLBACK_TEXTURE := "res://assets/npc/steve_reference.png"

@export var face_target := Vector3(0, 0, 0)

func _ready() -> void:
	_face_target()
	_apply_body_texture()

func _face_target() -> void:
	look_at(Vector3(face_target.x, global_position.y, face_target.z), Vector3.UP)

func _apply_body_texture() -> void:
	var body_mesh: MeshInstance3D = get_node_or_null("FullBody")
	if not body_mesh:
		return
	var mat := body_mesh.get_active_material(0) as StandardMaterial3D
	if not mat:
		return
	var tex := _load_texture(BODY_TEXTURE)
	if not tex:
		tex = _load_texture(FALLBACK_TEXTURE)
	if tex:
		mat.albedo_texture = tex
		mat.albedo_color = Color.WHITE

func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		var resource: Resource = ResourceLoader.load(path)
		if resource is Texture2D:
			return resource
	var file_path := ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(file_path):
		return null
	var image := Image.load_from_file(file_path)
	if image.is_empty():
		return null
	return ImageTexture.create_from_image(image)
