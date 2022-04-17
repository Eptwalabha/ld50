extends Control

export(String, FILE, "*.tscn") var game_path = ""

func _ready() -> void:
	if Data.DEBUG:
		load_game()
	else:
		$AnimationPlayer.play("fade-in")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or Input.is_action_just_pressed("ui_cancel"):
		load_game()

func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	load_game()

func load_game() -> void:
	get_tree().change_scene(game_path)
