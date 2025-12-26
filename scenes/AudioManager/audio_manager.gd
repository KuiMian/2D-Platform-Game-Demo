extends Node2D

#region UI

var music_volumn_factor: float :
	set(v):
		music_volumn_factor = v
		AudioServer.set_bus_volume_linear(music_bus_idx, v)
			
var sfx_volumn_factor: float :
	set(v):
		sfx_volumn_factor = v
		AudioServer.set_bus_volume_linear(sfx_bus_idx, v)

#endregion UI

#region music & sfx list

# music
@onready var MUSIC_NODE: Node2D = $Music
@onready var menu_music: AudioStreamPlayer = $Music/MenuMusic
@onready var game_start_music: AudioStreamPlayer = $Music/GameStartMusic
@onready var game_end_music: AudioStreamPlayer = $Music/GameEndMusic

# sfx
@onready var SFX_NODE: Node2D = $SFX
@onready var attack_sfx: AudioStreamPlayer = $SFX/AttackSfx
@onready var button_sfx: AudioStreamPlayer = $SFX/ButtonSfx
@onready var dash_sfx: AudioStreamPlayer = $SFX/DashSfx
@onready var die_sfx: AudioStreamPlayer = $SFX/DieSfx
@onready var jump_sfx: AudioStreamPlayer = $SFX/JumpSfx
@onready var land_sfx: AudioStreamPlayer = $SFX/LandSfx
@onready var level_finish_sfx: AudioStreamPlayer = $SFX/LevelFinishSfx
@onready var logo_sfx: AudioStreamPlayer = $SFX/LogoSfx

var music_list: Dictionary
var sfx_list: Dictionary

var music_bus_idx: int
var sfx_bus_idx: int

#endregion music & sfx list


func _ready() -> void:
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	for music in MUSIC_NODE.get_children():
		var music_name := (music as AudioStreamPlayer).name.to_snake_case()
		music_list[music_name] = music
	
	for sfx in SFX_NODE.get_children():
		var sfx_name := (sfx as AudioStreamPlayer).name.to_snake_case()
		sfx_list[sfx_name] = sfx


func play_sfx(sfx_name: String) -> void:
	_play_with_random_pitch(sfx_list[sfx_name])

func _play_with_random_pitch(audio_player: AudioStreamPlayer):
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	audio_player.play()
	
func stop_all_music() -> void:
	for music: AudioStreamPlayer in MUSIC_NODE.get_children():
		if music.playing:
			music.stop()
