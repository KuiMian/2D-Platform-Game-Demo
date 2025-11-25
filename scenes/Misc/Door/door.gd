extends StaticBody2D
class_name Door


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_idle := true
# 其实门有四种状态，idle open close 还有open之后的idle 这里的is_idle指闭合时idle

var progress := 0

func _ready() -> void:
	animation_player.play("idle")

func _process(_delta: float) -> void:
	is_idle = animation_player.current_animation == "idle" or not animation_player.is_playing()
	print(is_idle)


func open() -> void:
	if animation_player.is_playing():
		animation_player.pause()
	
	animation_player.play("open")

func close() -> void:
	if animation_player.is_playing():
		animation_player.pause()
	
	animation_player.play_backwards("open")
	
