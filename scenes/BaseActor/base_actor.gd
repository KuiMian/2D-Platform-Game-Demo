extends CharacterBody2D
class_name BaseActor

#region Debug

@export_group("Debug")
@export var DEBUG := false
@export var interval := 1.0
var time_count := 0.0

@export var verbose := false

#endregion Debug

#region Physics
@export_group("Physics")

#region Basic physics

@export_subgroup("Basic physics")
@export var USE_GRAVITY := true
@export var gravity := 200.0
@export var SPEED := 300.0
@export var WALK_SPEED := 180
@export var RUN_SPEED := 300

enum Direction {None = 0, Left = -1, Right = 1}
var move_direction : Direction = Direction.None :
	set(v):
		move_direction = v
		_on_move_direction_changed()

var force_face_direction: Direction = Direction.None
@export var face_direction := Direction.Right :
	set(v):
		face_direction = v
		_on_face_direction_changed()

#endregion Basic physics

#region Advanced physics

@export_subgroup("Advanced physics")
@export var USE_ACCELERATION := false
@export var ACCELERATION := 120
@export var FRICTION_FACTOR := 2 * ACCELERATION
@export var USE_START_SPEED := false
@export var START_SPEED := 90
@export var START_SPEED_THRESHOLD := 1

#endregion Advanced physics

#region Skills physics

@export_subgroup("Skills physics")
@export_subgroup("Skills physics/Jump")
@export var JUMP_SKILL := false # 是否掌握这个技能
var can_jump: bool
@export var JUMP_SPEED := -300

@export_subgroup("Skills physics/Dash")
@export var DASH_SKILL := false
var can_dash := true
@export var DASH_SPEED := 600

@export_subgroup("Skills physics/Fly")
@export var FLY_SKILL := false
var can_fly := true

#endregion Skills physics

#endregion Physics

@onready var sprite_area: Area2D = $SpriteArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var state_machine: BaseStateMachine
@warning_ignore("unused_signal")
signal force_transition(force_state_str: String)

enum NormalSubState {IDLE, WALK, RUN, JUMP, FALL, STANDBY}
var normal_substate: NormalSubState = NormalSubState.IDLE



func _ready() -> void:
	if DEBUG:
		print("%s 已启用 Debug" % self.name)


func _process(delta: float) -> void:
	state_machine.process_update(delta)
	
	if DEBUG:
		time_count += delta
		if time_count > interval:
			debug()
			time_count = 0


func _physics_process(delta: float) -> void:
	state_machine.process_phy_update(delta)
	move_and_slide()


#region utils

func debug() -> void:
	pass

# 注入依赖
func inject_dependency() -> void:
	state_machine = $EnemyStateMachine
	state_machine.actor = self
	
	push_error("%s 未重载【依赖注入】" % self.name)
	#for state in state_machine.get_children():
		#(state as EnemyState).actor = self
		
	## Normal -> AttackJump 依赖注入
	#force_transition.connect((state_machine.get_child(0) as PlayerNormal)._set_force_state)

# 连接信号
func connect_signals() -> void:
	pass

# 施加重力
func apply_gravity(delta: float) -> void:
	# 不用重力就不要调用这个函数了
	if not USE_GRAVITY:
		push_error("USE_GRAVITY is disabled but still apply gravity!")
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
		can_dash = true

# 移动
func apply_movement(delta: float) -> void:
	var target_speed: float = move_direction * SPEED
	
	# 基于加速度移动
	if USE_ACCELERATION:
		var acceleration = ACCELERATION if move_direction * velocity.x > 0 else FRICTION_FACTOR
		# 【手感优化】如果移动方向与自身速度反向, 立即重置速度
		if move_direction * velocity.x < 0:
			velocity.x /= -8
	
		if USE_START_SPEED:
			# 检测刚开始移动的瞬间
			if move_direction != Direction.None and abs(velocity.x) < START_SPEED_THRESHOLD:
				# 添加启动冲量
				velocity.x = move_direction * START_SPEED
	
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	
	# 匀速移动
	else:
		velocity.x = target_speed

# 处理移动方向与朝向的关系
func _on_move_direction_changed() -> void:
	var _face_direction: Direction
	
	# 如果没有强制的朝向（受击反向等情景），朝向同移动方向
	if force_face_direction != Direction.None:
		face_direction = force_face_direction
	elif move_direction != Direction.None:
		face_direction = move_direction
	
	# 进入状态时设置face_direction，退出状态时记得reset


# 朝向处理
var flippable_nodes: Array = [
	"Area2D", 
	"CollisionShape2D", 
	"CollisionPolygon2D",
]

func _on_face_direction_changed() -> void:
	# 部分节点跟随朝向更新
	for node in get_children():
		# 下面错误的原因是 node (instance) != Area2D (Class)
		#if node in flippable_nodes:
		
		if flippable_nodes.any(
			func(t) -> bool:
				return node.is_class(t)
		):
			node.scale.x = face_direction

# 静止状态
func reset_velocitiy() -> void:
	velocity = Vector2.ZERO

# 刷新技能（比如二段跳、冲刺）
#func reset_skill() -> void:
	#can_dash = true
	#can_double_jump = true

# 改变health并同步更新UI
#func update_health(v: int) -> void:
	#Global_HUD.player_health += v

# 改变soul并同步更新UI
#func update_soul(v: int) -> void:
	#Global_HUD.player_soul += v

#endregion utils
