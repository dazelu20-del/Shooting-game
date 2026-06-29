class_name GameStateService
extends Node

enum ReturnReason { FRESH, DIED, QUIT }

static func resolve() -> GameStateService:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return null
	return tree.root.get_node_or_null("GameState") as GameStateService

var return_reason := ReturnReason.FRESH
var last_survival_time := 0.0

func set_died() -> void:
	return_reason = ReturnReason.DIED

func set_quit() -> void:
	return_reason = ReturnReason.QUIT

func set_fresh() -> void:
	return_reason = ReturnReason.FRESH

func set_survival_time(seconds: float) -> void:
	last_survival_time = max(seconds, 0.0)

func format_survival_time(seconds: float) -> String:
	var total := int(seconds)
	var mins := int(total / 60)
	var secs := total % 60
	return "%d:%02d" % [mins, secs]
