extends Node


export(String, FILE, "*.tscn") var start: String

var _active_scene: Node

onready var _current_scene := $CurrentScene


func _ready() -> void:
	if start:
		call_deferred("_change_scene", start)
	Pause.connect("scene_changed", self, "_change_scene", [], CONNECT_DEFERRED)


func _change_scene(to: String) -> void:
	if not to:
		return
	if _active_scene:
		_active_scene.free()
	_active_scene = load(to).instance()
	add_child(_active_scene)
	if _active_scene.has_signal("scene_changed"):
		_active_scene.connect("scene_changed", self, "_change_scene", [], CONNECT_DEFERRED)
