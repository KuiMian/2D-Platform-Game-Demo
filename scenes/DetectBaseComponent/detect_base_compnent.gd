extends Area2D
class_name DetectBaseComponent


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready():
	# 绑定信号
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_body_entered(_body):
	#emit_signal("body_entered", body)
	pass

func _on_body_exited(_body):
	#emit_signal("body_exited", body)
	pass

func _on_area_entered(_area):
	#emit_signal("area_entered", area)
	pass

func _on_area_exited(_area):
	#emit_signal("area_exited", area)
	pass
