extends StaticBody2D
class_name Door


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_working := true

func _ready() -> void:
	animation_player.play("idle")


func open() -> void:
	animation_player.play("open")

func close() -> void:
	animation_player.play("close")
