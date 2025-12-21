extends BaseActor
class_name Player


@onready var hit_box_area: HitBoxArea = $HitBoxArea
@onready var hurt_box_area: HurtBoxArea = $HurtBoxArea

@export_subgroup("Skills physics/Push")
@export var PUSH_SPEED := 100
@export var push_factor = 50
var push_collision: KinematicCollision2D
var push_object: PushBox

var drag_collision: KinematicCollision2D
var drag_object: DragBox

func debug() -> void:
	print(last_velocity_y)


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
	is_in_air = not is_on_floor()
	last_velocity_y = velocity.y
	
	move_direction = sign(Input.get_axis("move_left", "move_right"))
	
	if is_on_floor():
		is_jumping = false
		can_jump = true
	
	if JUMP_SKILL and Input.is_action_just_pressed("jump"):
		if is_on_floor() and can_jump:
			can_jump = false
			is_jumping = true
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
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is SpikePit or collider is SpikeClub:
				#if collision.get_normal() == Vector2.UP:
				force_transition.emit("Die")
			
			if collider is PushBox:
				if Input.is_action_just_pressed("push") and get_main_axis_normal(collision.get_normal()).x != 0:
					push_collision = collision
					push_object = collider
					force_transition.emit("Push")
			
			if collider is DragBox:
				if Input.is_action_just_pressed("push") and get_main_axis_normal(collision.get_normal()).x != 0:
					drag_collision = collision
					drag_object = collider
					force_transition.emit("Push")

func get_main_axis_normal(normal: Vector2) -> Vector2:
	var abs_x = abs(normal.x)
	var abs_y = abs(normal.y)

	if abs_x > abs_y:
		if normal.x > 0:
			return Vector2.RIGHT  # (1, 0)
		else:
			return Vector2.LEFT   # (-1, 0)
	elif abs_y > 0:
		if normal.y > 0:
			return Vector2.DOWN   # (0, 1)
		else:
			return Vector2.UP     # (0, -1)
			
	return Vector2.ZERO

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
func physics_process4die(_delta: float) -> void:
	reset_velocitiy()

#func exit_die() -> void:
	#pass

func emit_die() -> void:
	player_died.emit()

#endregion die state

#region push state

func enter_push() -> void:
	animation_player.play("push")
	
	reset_velocitiy()
	
	fix_face_direction = true
	
	ban_skills()

func process4push(_delta: float) -> void:
	pass

func physics_process4push(delta: float) -> void:
	move_direction = sign(Input.get_axis("move_left", "move_right"))
	
	apply_movement(delta, PUSH_SPEED)
	
	if push_collision:
		(push_object as PushBox).apply_central_impulse(- push_collision.get_normal() * push_factor)

	if drag_collision:
		(drag_object as DragBox).velocity = - drag_collision.get_normal() * velocity.x


func exit_push() -> void:
	reset_skills()
	
	fix_face_direction = false
	
	push_object = null
	push_collision = null
	
	drag_object = null
	drag_collision = null

func ban_skills() -> void:
	can_jump = false
	can_dash = false
	can_fly = false

func reset_skills() -> void:
	can_jump = true
	can_dash = true
	can_fly = true

#endregion push state

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
