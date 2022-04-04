class_name AdScreen extends Node2D

export(bool) var on : bool = false

onready var item : AnimatedSprite = $Pivot/What
onready var pivot : Node2D = $Pivot
onready var timer : Timer = $Timer
var acc : float = 0.0

func _ready() -> void:
	turn(on)

func turn(is_on: bool) -> void:
	on = is_on
	if on:
		acc = 0.0
		timer.start(2.0)
	else:
		timer.stop()
	modulate = Color.white if on else Color.black

func _process(delta: float) -> void:
	acc += delta
	pivot.rotation_degrees = sin(3.0 * acc) * 30.0

func set_current_promotion(item_type: String, _duration: float) -> void:
	item.play("spin")
	yield(get_tree().create_timer(3), "timeout")
	item.stop()
	item.frame = Data.ITEMS.find(item_type)

func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("zoom")
