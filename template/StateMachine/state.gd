extends Node
class_name State

var state_machine: BaseStateMachine
var next_state_str: String
var is_active := false

@export var verbose := false


#region force change

const NO_FORCE := 'NO_FORCE'
var force_state_str := NO_FORCE

func _set_force_state(new_force_state_str: String) -> void:
	# 只针对当前状态强制转换
	if is_active:
		self.force_state_str = new_force_state_str

#endregion force change

func Enter() -> void:
	# 注意继承
	# super.Enter()
	
	next_state_str = self.name
	state_machine.state_enter.emit(state_machine.current_state_key)
	
	is_active = true
	
	if verbose:
		print("--- [%s] 已进入状态[%s] ---" % [owner.name, name])


func Exit() -> void:
	# 注意继承
	# super.Exit()
	next_state_str = self.name
	state_machine.state_exit.emit(state_machine.current_state_key)
	
	is_active = false
	
	if verbose:
		print("--- [%s] 已退出状态[%s] ---" % [owner.name, name])


func Update(_delta: float) -> void:
	# 注意继承
	# super.Update(_delta)
	state_machine.state_update.emit(state_machine.current_state_key)
	
	#if verbose:
		#print("--- 状态更新中[%s] ---" % name)

func Update_phy(_delta: float) -> void:
	# 注意继承
	# super.Update(_delta)
	state_machine.state_update_phy.emit(state_machine.current_state_key)
	
	#if verbose:
		#print("--- 状态更新中[%s] ---" % name)


func get_next_state_str() -> String:
	# 强制转换状态
	if force_state_str != NO_FORCE:
		force_change()
		
	# 常规状态切换的逻辑
	else:
		default_change()
	
	return owner.name.remove_chars("0123456789") + next_state_str


func force_change() -> void:
	var temp_state_str: String = force_state_str
	force_state_str = NO_FORCE
	next_state_str = temp_state_str

func default_change() -> void:
	pass


# 该函数不该在基类State节点使用
func get_current_state_str() -> String:
	if self.name == "State":
		push_error("get_state_str() 函数不该在基类State节点使用")
	return self.name.replace(owner.name.remove_chars("0123456789"), "") 


func handle_input(_event: InputEvent) -> void:
	#state_machine.state_update_phy.emit(state_machine.current_state_key)
	pass


# 复制到actor中作粘贴样例
##region xxx state
#
#func enter_xxx() -> void:
	#pass
#
#func process4xxx(_delta: float) -> void:
	#pass
#
#func physics_process4xxx(_delta: float) -> void:
	#pass
#
#func exit_xxx() -> void:
	#pass
#
##endregion xxx state
