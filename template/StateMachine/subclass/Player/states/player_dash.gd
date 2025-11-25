extends PlayerState
class_name PlayerDash


func Enter() -> void:
	super.Enter()
	
	actor.enter_dash()


func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4dash(delta)


func default_change() -> void:
	print(actor.animation_player.is_playing())
	next_state_str = "Normal" if not actor.animation_player.is_playing() else get_current_state_str()
