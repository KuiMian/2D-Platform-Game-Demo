extends CharacterBody2D
class_name DragBox

var gravity := 100

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity
	
	if get_slide_collision_count() == 0:
		velocity.x = 0
	
	move_and_slide()
