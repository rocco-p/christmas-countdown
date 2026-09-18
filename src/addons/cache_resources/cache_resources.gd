@tool
extends EditorExportPlugin

var export: bool = false
var directory: String = ""
var base_name: String = ""

func _get_name() -> String:
	return "CacheResources"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if features.has("web"):
		export = true
		base_name = path.get_file().get_basename()
		directory = path.get_base_dir()
	
func _export_end() -> void:
	if not export:
		return
		
	if directory.is_empty():
		return
		
	if not DirAccess.dir_exists_absolute(directory.path_join("scripts")):	
		DirAccess.make_dir_absolute(directory.path_join("scripts"))
		
	if not DirAccess.dir_exists_absolute(directory.path_join("assets")):
		DirAccess.make_dir_absolute(directory.path_join("assets"))
		
	DirAccess.copy_absolute("res://scripts/bgaudio.js", directory.path_join("scripts").path_join("bgaudio.js"))
	DirAccess.copy_absolute("res://assets/background_music.ogg", directory.path_join("assets").path_join("background_music.ogg"))
	
	var service_worker_file : String = directory.path_join(base_name + ".service.worker.js")
	if not FileAccess.file_exists(service_worker_file):
		return
		
	var file: FileAccess = FileAccess.open(service_worker_file, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	if content.contains("// patched"):
		return
		
	var files: Array = ["scripts/bgaudio.js", 
		"assets/background_music.ogg",
		"index.png"]
	
	files = files.map(func(content): return "\"" + content + "\"")
	const cached_files: String = "const CACHED_FILES = ["
	var new_cached_files: String = cached_files + ",".join(files) + ","

	content = content.replace(cached_files, new_cached_files)
	
	var install = "self.addEventListener('install', (event) => {"
	var new_install = install + "\n\tself.skipWaiting();"
	
	content = content.replace(install, new_install)
	content = "// patched\n" + content
	
	file = FileAccess.open(service_worker_file, FileAccess.WRITE)
	file.store_string(content)
	file.close()
