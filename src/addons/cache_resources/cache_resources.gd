@tool
extends EditorExportPlugin

var directory: String = ""

func _get_name() -> String:
	return "CacheResources"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	directory = path.get_base_dir()
	
func _export_end() -> void:
	if directory.is_empty():
		return
	
	var service_worker_file : String = directory.path_join("index.service.worker.js")
	if not FileAccess.file_exists(service_worker_file):
		return
		
	var file: FileAccess = FileAccess.open(service_worker_file, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var cached_files: String = "const CACHED_FILES = ["
	var new_cached_files: String = "const CACHED_FILES = [\"scripts/bgaudio.js\",\"assets/background_music.mp3\","

	if content.contains(cached_files) and not content.contains('bgaudio.js'):
		content = content.replace(cached_files, new_cached_files)
		
		file = FileAccess.open(service_worker_file, FileAccess.WRITE)
		file.store_string(content)
		file.close()
