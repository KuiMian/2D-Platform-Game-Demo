extends MushroomState
class_name MushroomDie


func Enter() -> void:
	super.Enter()
	
	actor.enter_die()

func default_change() -> void:
	next_state_str = get_current_state_str()
