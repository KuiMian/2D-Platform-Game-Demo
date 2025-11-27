extends CharacterBody2D
class_name FallSpike

@export var gravity: int = 100

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@export var detect_length: int

var can_fall: bool = false

func _ready() -> void:
	ray_cast_2d.target_position.y = detect_length


func _physics_process(delta: float) -> void:
	if can_fall:
		if not is_on_floor():
			velocity.y += gravity * delta
		
	if ray_cast_2d.is_colliding():
		#if ray_cast_2d.collide_with_bodies:
		var collider := ray_cast_2d.get_collider()
		if collider is Player:
			can_fall = true
		
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is Player:
				(collider as Player).force_transition.emit("Die")
			elif collider is TileMapLayer:
				can_fall = false
				set_physics_process(false)
			
		
		
	move_and_slide()
