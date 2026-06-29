extends Node3D

const DEFAULT_SPEED := 110.0
const DEFAULT_HIT_RADIUS := 0.15

var direction := Vector3.FORWARD
var speed := DEFAULT_SPEED
var damage := 10.0
var max_range := 40.0
var hit_radius := DEFAULT_HIT_RADIUS
var distance_traveled := 0.0
var owner_player: CharacterBody3D

var _sphere_shape := SphereShape3D.new()

func _ready() -> void:
	add_to_group("bullets")
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_physics_process(false)

func setup(origin: Vector3, dir: Vector3, bullet_damage: float, range_limit: float, owner: CharacterBody3D, bullet_speed: float = DEFAULT_SPEED, radius: float = DEFAULT_HIT_RADIUS) -> void:
	global_position = origin
	direction = dir.normalized()
	damage = bullet_damage
	max_range = range_limit
	owner_player = owner
	speed = bullet_speed
	hit_radius = radius
	_sphere_shape.radius = hit_radius
	if direction.length_squared() > 0.0001:
		look_at(origin + direction, Vector3.UP)

func _process(delta: float) -> void:
	if get_tree().paused:
		return

	var step := speed * delta
	if step <= 0.00001:
		return

	var from := global_position
	var motion := direction * step
	var hit := _cast_for_target(from, motion)
	if hit:
		global_position = hit.position
		_apply_damage(hit.target)
		queue_free()
		return

	global_position = from + motion
	distance_traveled += step
	if distance_traveled >= max_range:
		queue_free()

func _cast_for_target(from: Vector3, motion: Vector3) -> Dictionary:
	var space_state := get_world_3d().direct_space_state
	if not space_state:
		return {}

	var exclude: Array[RID] = []
	if owner_player:
		exclude.append(owner_player.get_rid())

	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = _sphere_shape
	params.transform = Transform3D(Basis(), from)
	params.motion = motion
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.exclude = exclude

	var safe_fraction := space_state.cast_motion(params)[0]
	var check_points: Array[Vector3] = [from + motion]
	if safe_fraction < 1.0:
		check_points.append(from + motion * safe_fraction)
	check_points.append(from + motion * 0.5)

	for point in check_points:
		var target := _find_damage_target_at(point, exclude)
		if target:
			return {"position": point, "target": target}

	var ray := PhysicsRayQueryParameters3D.create(from, from + motion)
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.hit_from_inside = true
	ray.exclude = exclude
	var ray_result := space_state.intersect_ray(ray)
	if ray_result:
		var target := _resolve_damage_target(ray_result.collider)
		if target:
			return {"position": ray_result.position, "target": target}

	return {}

func _find_damage_target_at(point: Vector3, exclude: Array[RID]) -> Object:
	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = _sphere_shape
	params.transform = Transform3D(Basis(), point)
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.exclude = exclude
	for hit in get_world_3d().direct_space_state.intersect_shape(params, 8):
		var target := _resolve_damage_target(hit.collider)
		if target:
			return target
	return null

func _resolve_damage_target(collider: Object) -> Object:
	if not collider:
		return null
	if collider.has_method("take_damage"):
		return collider
	if collider is Node:
		var parent: Node = (collider as Node).get_parent()
		if parent and parent.has_method("take_damage"):
			return parent
	return null

func _apply_damage(target: Object) -> void:
	if target and target.has_method("take_damage"):
		target.take_damage(int(damage))
