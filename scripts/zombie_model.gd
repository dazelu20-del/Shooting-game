extends Node3D

const BODY_TEXTURE := "res://assets/zombie/zombie_sprite.png"

func _ready() -> void:
	call_deferred("_apply_body_texture")

func _apply_body_texture() -> void:
	var body_mesh: MeshInstance3D = get_node_or_null("FullBody")
	if not body_mesh:
		return

	var mat := body_mesh.get_active_material(0) as StandardMaterial3D
	if not mat:
		return

	mat = mat.duplicate() as StandardMaterial3D
	body_mesh.set_surface_override_material(0, mat)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

	var tex := _load_texture(BODY_TEXTURE)
	if tex:
		mat.albedo_texture = tex
		mat.albedo_color = Color.WHITE

func _load_texture(path: String) -> Texture2D:
	var file_path := ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(file_path):
		push_warning("Zombie texture missing: %s" % path)
		return null

	var image := Image.load_from_file(file_path)
	if image.is_empty():
		push_warning("Zombie texture failed to load: %s" % path)
		return null

	return ImageTexture.create_from_image(image)
