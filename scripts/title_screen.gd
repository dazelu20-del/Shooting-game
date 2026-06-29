extends Control

@onready var title_label: Label = $CenterContainer/VBox/TitleLabel
@onready var status_label: Label = $CenterContainer/VBox/StatusLabel
@onready var action_button: Button = $CenterContainer/VBox/ActionButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_update_ui()
	action_button.pressed.connect(_on_action_pressed)

func _update_ui() -> void:
	var state := GameStateService.resolve()
	if state == null:
		status_label.text = "Survive the zombie outbreak."
		action_button.text = "Play"
		return
	match state.return_reason:
		GameStateService.ReturnReason.DIED:
			status_label.text = "You were overrun by zombies!\nYou survived %s." % state.format_survival_time(state.last_survival_time)
			action_button.text = "Respawn"
		GameStateService.ReturnReason.QUIT:
			status_label.text = "You left the battlefield.\nYou survived %s." % state.format_survival_time(state.last_survival_time)
			action_button.text = "Respawn"
		_:
			status_label.text = "Survive the zombie outbreak."
			action_button.text = "Play"

func _on_action_pressed() -> void:
	var state := GameStateService.resolve()
	if state:
		state.set_fresh()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
