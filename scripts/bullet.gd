extends Node3D

const DEFAULT_SPEED := 110.0

var direction := Vector3.FORWARD
var speed := DEFAULT_SPEED
var damage := 10.0
var max_range := 40.0
var distance_traveled := 0.0
var owner_player: CharacterBody3D

func setup(origin: Vector3, dir: Vector3, bullet_damage: float, range_limit: float, owner: CharacterBody3D, bullet_speed: float = DEFAULT_SPEED) -> void:
	global_position = origin
	direction = dir.normalized()
	damage = bullet_damage
	max_range = range_limit
	owner_player = owner
	speed = bullet_speed
	look_at(origin + direction, Vector3.UP)

func _physics_process(delta: float) -> void:
	var step := speed * delta
	var from := global_position
	var to := from + direction * step

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	if owner_player:
		query.exclude = [owner_player.get_rid()]

	var result := space_state.intersect_ray(query)
	if result:
		global_position = result.position
		_hit(result.collider)
		return

	global_position = to
	distance_traveled += step
	if distance_traveled >= max_range:
		queue_free()

func _hit(collider: Object) -> void:
	if collider and collider.has_method("take_damage"):
		collider.take_damage(damage)
	queue_free()
