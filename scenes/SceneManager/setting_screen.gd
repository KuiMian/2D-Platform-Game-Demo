extends Control
class_name SettingScreen

@export var title_screen: PackedScene

@onready var music_bar: HScrollBar = $VBoxContainer/MusicBar
@onready var sfx_bar: HScrollBar = $VBoxContainer/SFXBar
@onready var back_button: Button = $VBoxContainer/BackButton

var HAS_SAVING_FILE: bool = false

var music_UI_value: int :
	set(v):
		music_UI_value = v
		
		var middle := get_middle_value(bar_range_1)
		SoundManager.music_volumn_factor = 1.0 * music_UI_value / middle 
		
		
var sfx_UI_value: int :
	set(v):
		sfx_UI_value = v
		
		var middle := get_middle_value(bar_range_1)
		SoundManager.sfx_volumn_factor = 1.0 * sfx_UI_value / middle

# 各种Bar的范围
var bar_range_1: Array[int] = [0, 100]

func _ready() -> void:
	back_button.button_down.connect(_on_back_button_down)
	back_button.button_up.connect(_on_back_button_up)
	
	
	if not HAS_SAVING_FILE:
		music_UI_value = get_middle_value(bar_range_1)
		sfx_UI_value = get_middle_value(bar_range_1)
	
	if not SoundManager.menu_music.playing:
		SoundManager.menu_music.play()

func get_middle_value(bar_range: Array[int])-> int:
	return int((bar_range.front() + bar_range.back()) / 2)

func _on_back_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_back_button_up() -> void:
	SceneManager.change_scene(title_screen)
