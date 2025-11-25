extends PlayerState
class_name PlayerDie


func Enter() -> void:
	super.Enter()
	
	actor.enter_die()

func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4die(delta)

func default_change() -> void:
	next_state_str = get_current_state_str()
