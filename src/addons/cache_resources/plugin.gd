@tool
extends EditorPlugin

var export = EditorExportPlugin

func _enter_tree() -> void:
	export = preload("res://addons/cache_resources/cache_resources.gd").new()
	add_export_plugin(export)
	
func _exit_tree() -> void:
	remove_export_plugin(export)
	export = null
