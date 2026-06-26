extends Node3D

@export var weapon_id := ""
@export var weapon_name := "Shotgun"
@export var automatic := false
@export var pellet_count := 8
@export var spread_degrees := 6.0
@export var damage_per_pellet := 15
@export var max_range := 40.0
@export var fire_rate := 0.8
@export var bullet_speed := 110.0
@export var max_ammo := 8
@export var reload_time := 1.5

var ammo := 8
var can_fire := true
var is_reloading := false
var is_active := false
var owner_player: CharacterBody3D

@onready var muzzle: Marker3D = $Muzzle

const BULLET_SCENE := preload("res://scenes/bullet.tscn")

var hud: CanvasLayer

func _ready() -> void:
	ammo = max_ammo
	hud = get_tree().get_first_node_in_group("hud")

func get_id() -> String:
	if weapon_id != "":
		return weapon_id.to_lower()
	return weapon_name.to_lower().replace(" ", "")

func set_owner_player(player: CharacterBody3D) -> void:
	owner_player = player

func set_active(active: bool) -> void:
	is_active = active
	visible = active
	if active:
		_update_hud()

func _process(_delta: float) -> void:
	if not is_active or not automatic or is_reloading or not can_fire:
		return
	if Input.is_action_pressed("shoot"):
		_fire()

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	if event.is_action_pressed("shoot") and not automatic and can_fire and not is_reloading:
		_fire()
	if event.is_action_pressed("reload") and not is_reloading and ammo < max_ammo:
		_reload()

func _fire() -> void:
	if ammo <= 0:
		_reload()
		return
	if not can_fire or is_reloading:
		return

	ammo -= 1
	can_fire = false
	_update_hud()

	var origin := muzzle.global_position
	var base_dir := -muzzle.global_transform.basis.z.normalized()

	for i in pellet_count:
		var dir := base_dir
		dir = dir.rotated(muzzle.global_transform.basis.x, deg_to_rad(randf_range(-spread_degrees, spread_degrees)))
		dir = dir.rotated(muzzle.global_transform.basis.y, deg_to_rad(randf_range(-spread_degrees, spread_degrees)))
		dir = dir.normalized()
		_spawn_bullet(origin, dir)

	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _spawn_bullet(origin: Vector3, dir: Vector3) -> void:
	var bullet: Node3D = BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.setup(origin, dir, damage_per_pellet, max_range, owner_player, bullet_speed)

func _reload() -> void:
	is_reloading = true
	if hud:
		hud.show_message("Reloading %s..." % weapon_name)
	await get_tree().create_timer(reload_time).timeout
	ammo = max_ammo
	is_reloading = false
	_update_hud()

func _update_hud() -> void:
	if hud and hud.has_method("update_ammo"):
		hud.update_ammo(ammo, max_ammo, weapon_name)
