extends DetectBaseComponent
class_name Portal


@export var next_scene: PackedScene


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pass
