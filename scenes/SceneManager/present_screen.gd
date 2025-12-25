extends TextureRect
class_name PresentScreen

var duration := 1

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = SceneManager.get_last_trans_anim_duration() + duration
	timer.timeout.connect(_on_timeout)
	
	timer.start()

func _on_timeout() -> void:
	SceneManager.change_scene(SceneManager.Scenes.TITLE, "LightFade")
