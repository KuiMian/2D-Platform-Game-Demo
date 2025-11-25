extends StaticBody2D
class_name Switch


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: DetectBaseComponent = $InteractArea


@export var doors: Array[Door]

@export var default_dict: Dictionary = {
	"open_flag" : false,
}


var open_flag: bool = false :
	set(v):
		open_flag = v
		animation_player.play("right" if v else "left")


func _ready() -> void:
	open_flag = default_dict["open_flag"]
	
	interact_area.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Area2D and area.owner is Player:
		var _door := doors[0]
		if not _door.is_working:
			open_flag = !open_flag
			
			for door in doors:
				if open_flag:
					(door as Door).open()
				else:
					(door as Door).close()
