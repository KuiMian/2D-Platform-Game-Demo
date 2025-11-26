extends RigidBody2D
class_name PushBox


@export var MAX_SPEED := 2


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if self.linear_velocity.length() > MAX_SPEED:
		self.linear_velocity = self.linear_velocity.normalized() * MAX_SPEED
