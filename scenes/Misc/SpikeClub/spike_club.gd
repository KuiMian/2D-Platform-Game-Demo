extends RigidBody2D
class_name SpikeClub

@export var start_degree := -90
@export var rotation_range := 180
@export var rotate_speed := 45
var positive_flag := 1
var degree_count := 0.0

func _ready() -> void:
	self.rotation_degrees = start_degree

func _physics_process(delta: float) -> void:
	#if positive_flag:
		#degree_count += rotate_speed * delta
		#self.rotation_degrees += start_degree + degree_count
		#
		#if degree_count > rotation_range:
			#positive_flag *= -1
			#degree_count = 0
	#else:
		#degree_count += rotate_speed * delta
		#self.rotation_degrees += start_degree + rotation_range - degree_count
		#if degree_count > rotation_range:
			#positive_flag *= -1
			#degree_count = 0
	
	degree_count += rotate_speed * delta
	self.rotation_degrees = start_degree + positive_flag * degree_count
	if positive_flag < 0:
		self.rotation_degrees += rotation_range
		
	if degree_count > rotation_range:
			positive_flag *= -1
			degree_count = 0
