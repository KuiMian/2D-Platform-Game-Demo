extends Control
class_name TitleScreen

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var setting_button: Button = $VBoxContainer/SettingButton


func _ready() -> void:
	start_button.button_down.connect(_on_start_button_down)
	start_button.button_up.connect(_on_start_button_up)
	setting_button.button_down.connect(_on_setting_button_down)
	setting_button.button_up.connect(_on_setting_button_up)


func _on_start_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_start_button_up() -> void:
	SoundManager.stop_all_music()
	SceneManager.change_scene(SceneManager.Scenes.Level1, "DarkFade")
	SoundManager.game_start_music.play()

func _on_setting_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_setting_button_up() -> void:
	SceneManager.change_scene(SceneManager.Scenes.SETTINGS, "DarkFade")
