extends Control
class_name SettingScreen

@export var title_screen: PackedScene

@onready var music_bar: HScrollBar = $VBoxContainer/MusicBar
@onready var sfx_bar: HScrollBar = $VBoxContainer/SFXBar
@onready var back_button: Button = $VBoxContainer/BackButton

var HAS_SAVING_FILE: bool = false

# 各种Bar的范围
var bar_range_1: Array[int] = [0, 20]

func _ready() -> void:
	back_button.button_down.connect(_on_back_button_down)
	back_button.button_up.connect(_on_back_button_up)
	
	music_bar.scrolling.connect(_on_music_bar_scrolling)
	sfx_bar.scrolling.connect(_on_sfx_bar_scrolling)
	
	var middle := get_middle_value(bar_range_1)
	if Saving.music_volumn_per:
		music_bar.value = middle * Saving.music_volumn_per
		sfx_bar.value = middle * Saving.sfx_volumn_per
	
	if not SoundManager.menu_music.playing:
		SoundManager.menu_music.play()

func get_middle_value(bar_range: Array[int])-> int:
	return int((bar_range.front() + bar_range.back()) / 2)

func _on_back_button_down() -> void:
	SoundManager.button_sfx.play()

func _on_back_button_up() -> void:
	SceneManager.change_scene(SceneManager.Scenes.TITLE)


func _on_music_bar_scrolling() -> void:
	var middle := get_middle_value(bar_range_1)
	Saving.music_volumn_per = music_bar.value / middle 
	SoundManager.music_volumn_factor = Saving.music_volumn_per


func _on_sfx_bar_scrolling() -> void:
	var middle := get_middle_value(bar_range_1)
	Saving.sfx_volumn_per = sfx_bar.value / middle 
	SoundManager.sfx_volumn_factor = Saving.sfx_volumn_per
