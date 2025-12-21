extends Node2D

# music
@onready var menu_music: AudioStreamPlayer = $Music/MenuMusic
@onready var game_start_music: AudioStreamPlayer = $Music/GameStartMusic
@onready var game_end_music: AudioStreamPlayer = $Music/GameEndMusic

# sfx
@onready var attack_sfx: AudioStreamPlayer = $SFX/AttackSfx
@onready var button_sfx: AudioStreamPlayer = $SFX/ButtonSfx
@onready var dash_sfx: AudioStreamPlayer = $SFX/DashSfx
@onready var die_sfx: AudioStreamPlayer = $SFX/DieSfx
@onready var jump_sfx: AudioStreamPlayer = $SFX/JumpSfx
@onready var land_sfx: AudioStreamPlayer = $SFX/LandSfx
@onready var level_finish_sfx: AudioStreamPlayer = $SFX/LevelFinishSfx
@onready var logo_sfx: AudioStreamPlayer = $SFX/LogoSfx
