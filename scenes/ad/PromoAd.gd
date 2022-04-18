class_name AdScreen extends Node2D

export(bool) var on : bool = false

onready var item : AnimatedSprite = $Pivot/What
onready var pivot : Node2D = $Pivot
onready var timer : Timer = $Timer
onready var roulette : Timer = $Roulette

var current_item_type : String = ""
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
	current_item_type = item_type
	item.play("spin")
	roulette.start(2.5)

func _on_Timer_timeout() -> void:
	$AnimationPlayer.play("zoom")

func _on_Roulette_timeout() -> void:
	item.stop()
	item.frame = Data.ITEMS.find(current_item_type)
