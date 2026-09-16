extends Node

@onready var canvas: CanvasLayer = $Canvas
@onready var seconds: Label = $Canvas/VContainer/Seconds
@onready var timer: Timer = $Timer

const FIREWORK_SCENE: PackedScene = preload("res://scenes/Firework.tscn")
const SNOW_SCENE: PackedScene = preload("res://scenes/Snowflakes.tscn")

func _ready() -> void:
	var firework_warmup: CPUParticles2D = FIREWORK_SCENE.instantiate()
	firework_warmup.modulate = Color(0,0,0,0.01)
	canvas.add_child(firework_warmup)
	firework_warmup.restart()
	
	var snow_warmup: CPUParticles2D = SNOW_SCENE.instantiate()
	snow_warmup.one_shot = true
	snow_warmup.lifetime = 0.1
	snow_warmup.modulate = Color(0, 0, 0, 0.01)
	canvas.add_child(snow_warmup)
	snow_warmup.restart()
	
	await get_tree().process_frame
	
	_refresh()
	timer.timeout.connect(_refresh)
	
func _refresh() -> void:
	var result = Global.christmas_countdown()

	if result.seconds > 0:
		seconds.text = str(result.seconds)
	else:
		seconds.text = tr("INTRO_CHRISTMAS")
		timer.stop()
	
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventScreenTouch \
		or event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT :
			timer.stop()
			
			Global.magic_sound.play()
			get_tree().change_scene_to_file("res://scenes/CountdownScreen.tscn")
