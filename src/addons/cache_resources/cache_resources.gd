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
	
	if content.contains("// patched"):
		return
	
	const cached_files: String = "const CACHED_FILES = ["
	const new_cached_files: String = cached_files + "\"scripts/bgaudio.js\",\"assets/background_music.mp3\","

	content = content.replace(cached_files, new_cached_files)
	
	var install = "self.addEventListener('install', (event) => {"
	var new_install = install + "\n\tself.skipWaiting();"
	
	content = content.replace(install, new_install)
	content = "// patched\n" + content
	
	file = FileAccess.open(service_worker_file, FileAccess.WRITE)
	file.store_string(content)
	file.close()
