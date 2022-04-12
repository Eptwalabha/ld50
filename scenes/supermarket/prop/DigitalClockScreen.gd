class_name DigitalClockScreen extends Node2D

signal ticked

export(bool) var running := false
var time_amount : int = 60
var acc : float = 0.0
var next_acc : float = 0.0

func _ready() -> void:
	reset(running)

func _process(delta: float) -> void:
	if running:
		acc += delta
		if acc > next_acc:
			next_acc += 1.0
			update_clock()

func update_clock() -> void:
	var t : int = time_amount - int(floor(acc))
	t = int(max(0.0, t))
	var minutes : int = t / 60
	var secondes : int = t % 60
	var s1 : int = secondes / 10
	var s2 : int = secondes % 10
	var m1 : int = minutes / 10
	var m2 : int = minutes % 10
	$Pivot/M1.frame = m1
	$Pivot/M2.frame = m2
	$Pivot/S1.frame = s1
	$Pivot/S2.frame = s2
	if t >= 0:
		emit_signal("ticked")

func add_time_bonus(time_bonus: float) -> void:
	acc = max(0.0, acc - time_bonus)
	next_acc = floor(acc + 1.0)
	update_clock()

func reset(remaining: int, is_running : bool = true) -> void:
	time_amount = remaining
	running = is_running
	acc = 0.0
	next_acc = 0.0

func start(time: float) -> void:
	time_amount = time
	reset(true)

func set_time(time_left: float) -> void:
	pass


func _on_Timer_timeout() -> void:
	pass # Replace with function body.
