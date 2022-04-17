class_name DigitalClock extends Spatial

signal timeout

onready var screen : DigitalClockScreen = $Viewport/Screen

export(bool) var running := false
var time : int = 60
export(float, 0.0, 20.0) var time_factor: float = 1.0

func _ready() -> void:
	screen.reset(120, true)
	screen.time_factor = time_factor

func start(the_time: float) -> void:
	time = int(the_time)
	screen.reset(time, true)

func reset(is_running : bool = true) -> void:
	screen.reset(time, is_running)

func add_time_bonus(time_bonus: float) -> void:
	screen.add_time_bonus(time_bonus)

func _on_Screen_ticked() -> void:
	$TicTac.play()


func _on_Screen_timeout() -> void:
	emit_signal("timeout")
