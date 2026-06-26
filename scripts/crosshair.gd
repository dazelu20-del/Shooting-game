extends Control

@export var line_color := Color(1, 1, 1, 0.92)
@export var outline_color := Color(0, 0, 0, 0.75)
@export var arm_length := 10.0
@export var line_width := 2.0
@export var center_gap := 4.0
@export var outline_width := 1.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()

func _draw() -> void:
	var center := size * 0.5
	var half_gap := center_gap * 0.5
	var half_thick := line_width * 0.5

	# Horizontal arms
	_draw_arm(
		Vector2(center.x - half_gap - arm_length, center.y - half_thick),
		Vector2(arm_length, line_width)
	)
	_draw_arm(
		Vector2(center.x + half_gap, center.y - half_thick),
		Vector2(arm_length, line_width)
	)
	# Vertical arms
	_draw_arm(
		Vector2(center.x - half_thick, center.y - half_gap - arm_length),
		Vector2(line_width, arm_length)
	)
	_draw_arm(
		Vector2(center.x - half_thick, center.y + half_gap),
		Vector2(line_width, arm_length)
	)

func _draw_arm(rect_pos: Vector2, rect_size: Vector2) -> void:
	if outline_width > 0.0:
		draw_rect(
			Rect2(rect_pos - Vector2(outline_width, outline_width), rect_size + Vector2(outline_width, outline_width) * 2.0),
			outline_color
		)
	draw_rect(Rect2(rect_pos, rect_size), line_color)
