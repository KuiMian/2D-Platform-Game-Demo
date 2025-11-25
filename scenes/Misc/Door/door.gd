extends StaticBody2D
class_name Door


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_working := true

var progress := 0

func _ready() -> void:
	animation_player.play("idle")

#func _process(_delta: float) -> void:
	#if is_working:
		#progress = animation_player.current_animation_position


func open() -> void:
	if animation_player.is_playing():
		animation_player.pause()
	
	is_working = true
	animation_player.play("open")
	
	await animation_player.animation_finished
	is_working = false

func close() -> void:
	if animation_player.is_playing():
		animation_player.pause()
	
	is_working = true
	animation_player.play_backwards("open")
	
	await animation_player.animation_finished
	is_working = false
