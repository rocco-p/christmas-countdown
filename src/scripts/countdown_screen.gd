extends Node2D

var rng = RandomNumberGenerator.new()

@onready var canvas: CanvasLayer = $Canvas
@onready var text: RichTextLabel = $Canvas/Text
@onready var christmas_tree: TextureRect = $Canvas/ChristmasTree
@onready var timer: Timer = $Timer
@onready var snow: CPUParticles2D = $Canvas/Snow
@onready var firework_sound: AudioStreamPlayer = $FireworkSound

const FIREWORK_SCENE = preload("res://scenes/Firework.tscn")

func _ready() -> void:		
	_refresh()
	
	get_viewport().size_changed.connect(_positionSnow)
	_positionSnow()
	timer.timeout.connect(_refresh)
	
	if OS.has_feature("web"):
		JavaScriptBridge.eval("playAudio();")
	else:
		var stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
		stream_player.stream = preload("res://assets/background_music.ogg")
		stream_player.stream.loop = true
		stream_player.autoplay = true
		add_child(stream_player)
	
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventScreenTouch \
		or event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:		
			_firework(event.position)
			
	if Input.is_key_pressed(KEY_C):
		_screenshot()
		
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
			
func _firework(pos: Vector2) -> void:
	firework_sound.play()
	var instance = FIREWORK_SCENE.instantiate()
	instance.texture = Global.COLORS[rng.randi() % len(Global.COLORS)]
	
	instance.global_position = pos
	canvas.add_child(instance)
	
func _positionSnow() -> void:
	var size: Vector2 = get_viewport_rect().size
				
	snow.position = Vector2(size.x / 2.0, 0)
	snow.emission_rect_extents.x = size.x / 2.0
	snow.restart()
	
func _refresh() -> void:
	var result: Dictionary = Global.christmas_countdown()
	text.text = result.text
	
	if (result.code < 0):
		timer.stop()
		return
		
func _screenshot() -> void:
	var sub_viewport: SubViewport = SubViewport.new()
	sub_viewport.size = Vector2i(1080, 1080)
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(sub_viewport)
	
	var cloned: CanvasLayer = canvas.duplicate(DUPLICATE_USE_INSTANTIATION)
	
	var snow_node: Node = cloned.find_child("Snow", true, false)
	if snow_node:
		snow_node.visible = false

	sub_viewport.add_child(cloned)
	
	await RenderingServer.frame_post_draw
	var image: Image = sub_viewport.get_texture().get_image()
	sub_viewport.queue_free()

	image.save_png("user://capture.png")
	
