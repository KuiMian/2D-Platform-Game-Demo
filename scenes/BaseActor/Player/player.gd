extends BaseActor
class_name Player


@onready var hit_box_area: HitBoxArea = $HitBoxArea
@onready var hurt_box_area: HurtBoxArea = $HurtBoxArea


func debug() -> void:
	print(sprite_area.scale.x)


func _ready() -> void:
	super._ready()
	
	inject_dependency()
	
	connect_signals()

func inject_dependency() -> void:
	state_machine = $PlayerStateMachine
	state_machine.actor = self
	
	for state in state_machine.get_children():
		(state as PlayerState).actor = self
		
	# 强制状态转换
	for state in state_machine.get_children():
		force_transition.connect((state as PlayerState)._set_force_state)
	
	state_machine.init_state_machine()

func connect_signals() -> void:
	pass


#region state

#region normal state

func enter_normal() -> void:
	normal_substate = NormalSubState.IDLE


func physics_process4normal(delta: float) -> void:
	
	move_direction = sign(Input.get_axis("move_left", "move_right"))
	
	if is_on_floor():
		can_jump = true
	
	if JUMP_SKILL and Input.is_action_just_pressed("jump"):
		if is_on_floor() and can_jump:
			can_jump = false
			velocity.y = JUMP_SPEED

	
	apply_gravity(delta)
	apply_movement(delta)
	
	update_animation()
	
	check_collider()

func exit_normal() -> void:
	pass


func update_animation() -> void:
	if is_on_floor():
		animation_player.play("walk" if velocity.x != 0 else "idle")
	else:
		animation_player.play("jump" if velocity.y <= 0 else "fall")

func check_collider() -> void:
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var collider := get_slide_collision(i).get_collider()
			if collider is PushBox:
				if Input.is_action_just_pressed("push&drag"):
					force_transition.emit("Die")
			

#endregion normal state

#region dash state

func enter_dash() -> void:
	can_dash = false
	animation_player.play("dash")
	

func process4dash(_delta: float) -> void:
	pass

func physics_process4dash(_delta: float) -> void:
	velocity.x = face_direction * DASH_SPEED
	velocity.y = 0

func exit_dash() -> void:
	pass

#endregion dash state

#region attack state

func enter_attack() -> void:
	animation_player.play("attack")

func process4attack(_delta: float) -> void:
	pass

func physics_process4attack(delta: float) -> void:
	apply_gravity(delta)
	apply_movement(delta)

func exit_attack() -> void:
	pass

#endregion attack state

#region die state

signal player_died

func enter_die() -> void:
	animation_player.play("die")

#func process4die(_delta: float) -> void:
	#pass
#
#func physics_process4die(_delta: float) -> void:
	#pass
#
#func exit_die() -> void:
	#pass

func emit_die() -> void:
	player_died.emit()

#endregion die state

#region xxx state

func enter_xxx() -> void:
	pass

func process4xxx(_delta: float) -> void:
	pass

func physics_process4xxx(_delta: float) -> void:
	pass

func exit_xxx() -> void:
	pass

#endregion xxx state

#endregion state
