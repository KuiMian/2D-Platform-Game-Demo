extends MushroomState
class_name MushroomStandby


func Enter() -> void:
	super.Enter()
	
	actor.enter_standby()

func Update_phy(delta: float) -> void:
	actor.physics_process4standby(delta)

func Exit() -> void:
	# force_change (比如强制转成受击状态) 但timer还未停止
	actor.stand_by_timer.stop()

func default_change() -> void:
	if actor.stand_by_timer.is_stopped():
		next_state_str = "Move"  
	else:
		next_state_str = get_current_state_str()
