extends Node3D

const BODY_TEXTURE := "res://assets/zombie/zombie_sprite.png"
const FALLBACK_TEXTURE := "res://assets/zombie/zombie_reference.png"
const FALLBACK_COLOR := Color(0.55, 0.58, 0.55, 1)

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
	if not tex:
		tex = _load_texture(FALLBACK_TEXTURE)
	if tex:
		mat.albedo_texture = tex
		mat.albedo_color = Color.WHITE
	else:
		mat.albedo_texture = null
		mat.albedo_color = FALLBACK_COLOR
		push_warning("Zombie sprite textures failed to load; using fallback color.")

func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		var resource: Resource = ResourceLoader.load(path)
		if resource is Texture2D:
			return resource

	var file_path := ProjectSettings.globalize_path(path)
	if not FileAccess.file_exists(file_path):
		return null

	var image: Variant = Image.load_from_file(file_path)
	if image == null or not (image is Image) or image.is_empty():
		return null

	return ImageTexture.create_from_image(image)
