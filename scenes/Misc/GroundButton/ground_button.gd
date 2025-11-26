extends StaticBody2D
class_name GroundButton


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: DetectBaseComponent = $InteractArea

@export var default_values: Dictionary = {
	"is_pressed" : false,
}

@export var doors: Array[Door]


var is_pressed: bool :
	set(v):
		is_pressed = v
		animation_player.play("press" if v else "unpress")

func _ready() -> void:
	is_pressed = default_values["is_pressed"]
	
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: PhysicsBody2D) -> void:
	print(body)
	if body is Player or PushBox:
		is_pressed = true
		
		var _door := doors[0]
		
		for door in doors:
			(door as Door).open()

func _on_body_exited(body: PhysicsBody2D) -> void:
	if body is Player or PushBox:
		is_pressed = false
		
		var _door := doors[0]

		for door in doors:
			(door as Door).close()
