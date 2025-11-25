extends StaticBody2D
class_name Switch


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: DetectBaseComponent = $InteractArea


@export var doors: Array[Door]

@export var default_dict: Dictionary = {
	"flag" : false,
}


var flag: bool = false :
	set(v):
		flag = v
		animation_player.play("right" if v else "left")


func _ready() -> void:
	flag = default_dict["flag"]
	
	interact_area.area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Area2D and area.owner is Player:
		var _door := doors[0]
		if not _door.is_working:
			flag = !flag
			
			for door in doors:
				if flag:
					(door as Door).open()
				else:
					(door as Door).close()
