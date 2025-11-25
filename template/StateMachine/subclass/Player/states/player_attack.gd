extends PlayerState
class_name PlayerAttack


func Enter() -> void:
	super.Enter()
	
	actor.enter_attack()


func Update_phy(delta: float) -> void:
	super.Update_phy(delta)
	
	actor.physics_process4attack(delta)


func default_change() -> void:
	next_state_str = "Normal" if not actor.animation_player.is_playing() else get_current_state_str()
