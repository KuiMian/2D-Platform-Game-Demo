extends PlayerState
class_name PlayerPush


func Enter() -> void:
	super.Enter()
	
	actor.enter_push()

func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4push(delta)

func Exit() -> void:
	super.Exit()
	
	actor.exit_push()


func default_change() -> void:
	next_state_str = "Normal" if not Input.is_action_pressed("push&drag") else get_current_state_str()
