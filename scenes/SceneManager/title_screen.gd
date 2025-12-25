extends Control
class_name TitleScreen

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var setting_button: Button = $VBoxContainer/SettingButton

@export var level_scene: PackedScene
@export var setting_scene: PackedScene


func _ready() -> void:
	start_button.button_down.connect(_on_start_button_down)
	start_button.button_up.connect(_on_start_button_up)
	setting_button.button_down.connect(_on_setting_button_down)
	setting_button.button_up.connect(_on_setting_button_up)


func _on_start_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_start_button_up() -> void:
	SoundManager.stop_all_music()
	SceneManager.change_scene(level_scene, "DarkFade")
	SoundManager.game_start_music.play()

func _on_setting_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_setting_button_up() -> void:
	SceneManager.change_scene(setting_scene, "DarkFade")
