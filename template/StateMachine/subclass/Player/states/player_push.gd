extends PlayerState
class_name PlayerPush


func default_change() -> void:
	next_state_str = "Normal" if not Input.is_action_pressed("push&drag") else get_current_state_str()
