extends PlayerState
class_name PlayerNormal


func Enter() -> void:
	super.Enter()
	
	actor.enter_normal()

func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4normal(delta)


func default_change() -> void:
	if Input.is_action_just_pressed("attack"):
		next_state_str = "Attack"
	elif Input.is_action_just_pressed("die"):
		next_state_str = "Die"
	elif Input.is_action_just_pressed("dash") and actor.can_dash:
		next_state_str = "Dash"
	else:
		next_state_str = get_current_state_str()
