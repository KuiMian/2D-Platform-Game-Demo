extends DetectBaseComponent
class_name Portal


@export var next_scene: SceneManager.Scenes


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneManager.change_scene.call_deferred(next_scene, "ResetLevelFade")
