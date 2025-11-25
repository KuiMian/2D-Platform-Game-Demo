extends BaseActor
class_name Mushroom

@onready var hurt_box_area: HurtBoxArea = $HurtBoxArea

@onready var timer_manager: Node = $TimerManager
@onready var idle_timer: Timer = $TimerManager/IdleTimer
@onready var walk_timer: Timer = $TimerManager/WalkTimer


func debug() -> void:
	print(hurt_box_area.collision_shape_2d.shape)


func _ready() -> void:
	super._ready()
	
	inject_dependency()
	
	connect_signals()


func inject_dependency() -> void:
	state_machine = $MushroomStateMachine
	state_machine.actor = self
	
	for state in state_machine.get_children():
		(state as MushroomState).actor = self
		
	# 强制状态转换
	for state in state_machine.get_children():
		force_transition.connect((state as MushroomState)._set_force_state)
		
	state_machine.init_state_machine()

func connect_signals() -> void:
	hurt_box_area.area_entered.connect(_on_hurt_box_area_area_entered)

#region standby state

func enter_standby() -> void:
	animation_player.play("standby")
	
	reset_velocitiy()
	
	idle_timer.start()


#func process4standby(_delta: float) -> void:
	#pass

func physics_process4standby(delta: float) -> void:
	apply_gravity(delta)

#func exit_standby() -> void:
	#pass

#endregion standby state

#region normal state

func enter_normal() -> void:
	normal_substate = NormalSubState.IDLE
	idle_timer.start()


func physics_process4normal(delta: float) -> void:
	apply_gravity(delta)
	apply_movement(delta)
	
	check_normal_substate(delta)
	
	update_animation()

func exit_normal() -> void:
	pass

# 这个函数主要还是给非玩家角色用，玩家角色依靠输入事件切换子状态。
# 酌情考虑拆成IDLE、WALK等状态
func check_normal_substate(_delta: float) -> void:
	match normal_substate:
		NormalSubState.IDLE:
			reset_velocitiy()
			
			if idle_timer.is_stopped():
				move_direction = Direction.Left if randf() < 0.5 else Direction.Right
				normal_substate = NormalSubState.WALK
				walk_timer.start()
			
		NormalSubState.WALK:
			if is_on_floor():
				velocity.y = -100 if randf() < 0.004 else 0
			
			if walk_timer.is_stopped() and is_on_floor():
				normal_substate = NormalSubState.IDLE
				idle_timer.start()


func update_animation() -> void:
	animation_player.play("move" if velocity.x != 0 else "idle")

#endregion normal state


#region hit & hurt box

func _on_hurt_box_area_area_entered(area: Area2D) -> void:
	# 不需要再检测是否为hit box，因为已经在 layer & mask 检测了
	if area.owner is Player:
		var force_state_str := "Die"
		force_transition.emit(force_state_str)

#endregion hit & hurt box



#region die state

func enter_die() -> void:
	animation_player.play("die")

func process4die(_delta: float) -> void:
	pass

func physics_process4die(_delta: float) -> void:
	pass

func exit_die() -> void:
	pass

#endregion die state


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
