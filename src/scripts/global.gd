extends Node

var magic_sound: AudioStreamPlayer = AudioStreamPlayer.new()

const COLORS: Array[GradientTexture2D] = [
	preload("res://textures/firework_blue.tres"),
	preload("res://textures/firework_yellow.tres"),
	preload("res://textures/firework_magenta.tres"),
	preload("res://textures/firework_purple.tres"),
	preload("res://textures/firework_orange.tres"), 
	preload("res://textures/firework_green.tres")
	]

func _ready() -> void:
	get_window().focus_entered.connect(_on_window_focus_entered)
	get_window().focus_exited.connect(_on_window_focus_exited)
	
	if OS.has_feature("web"):
		JavaScriptBridge.eval("initAudio('assets/background_music.mp3');")

func _init() -> void:		
	magic_sound = AudioStreamPlayer.new()
	magic_sound.stream = preload("res://assets/magic.wav")
	add_child(magic_sound)
		
func christmas_countdown() -> Dictionary:
	# Texte à afficher
	var text_string: String = "[font_size=120][color=red]C'est Noël dans[/color][/font_size]\n"
	text_string += "[font_size=80]"
	text_string += "[color=green]%02d[/color] [color=red]jours[/color]\n"
	text_string += "[color=green]%02d[/color] [color=red]heures[/color]\n"
	text_string += "[color=green]%02d[/color] [color=red]minutes[/color]\n"
	text_string += "[color=green]%02d[/color] [color=red]secondes[/color]\n"
	text_string += "[/font_size]"
	
	var now: Dictionary = Time.get_datetime_dict_from_system(false)	
	var year: int = now["year"]
		
	if now["month"] == 12 and now["day"] >= 26:
		year += 1
		
	var christmas_date: Dictionary = {
		"year": year, 
		"month": 12,
		"day": 25,
		"hour": 0,
		"minute": 0,
		"second": 0
	}
				
	var today: int = Time.get_unix_time_from_datetime_dict(now)
	var christmas: int = Time.get_unix_time_from_datetime_dict(christmas_date)
	
	var total_seconds: int = christmas - today
	
	if (total_seconds <= 0):
		return {"code": -1, "text": "[font_size=120][color=red]Joyeux Noël ![/color][/font_size]"}
	
	var days: int = int(total_seconds / 86400.0)
	var remaining: int = int(total_seconds) % 86400
	
	var hours: int = int(remaining / 3600.0)
	remaining %= 3600
	
	var minutes: int = int(remaining / 60.0)
	var seconds = remaining % 60
	
	return {"code": 0,"seconds": total_seconds, "text": text_string % [days, hours, minutes, seconds]}

func _on_window_focus_entered() -> void:
	if OS.has_feature("web"):
		AudioServer.set_bus_mute(0, false)
		JavaScriptBridge.eval("pauseAudio();")

func _on_window_focus_exited() -> void:
	if OS.has_feature("web"):
		AudioServer.set_bus_mute(0, true)
		JavaScriptBridge.eval("resumeAudio();")
