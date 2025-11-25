extends MushroomState
class_name MushroomNormal


func Enter() -> void:
	super.Enter()
	
	actor.enter_normal()


func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4normal(delta)


func default_change() -> void:
	#if actor.move_timer.is_stopped():
		#next_state_str = "Standby"  
	#else:
	next_state_str = get_current_state_str()
