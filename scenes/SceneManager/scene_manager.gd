extends CanvasLayer

const LOGO_SCREEN = preload("uid://bm8tel667wynk")

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var color_dark := Color(0.231, 0.194, 0.265, 1.0)
var color_light := Color(0.231, 0.194, 0.265, 0.0)

var last_trans_anim: String = ''

func _ready() -> void:
	# 此时（最近一帧）SceneManager正在加入场景树。
	# 如果立刻切换场景，会先销毁正在运行的当前场景,产生冲突。
	#change_scene(LOGO_SCREEN)
	
	#change_scene.call_deferred(LOGO_SCREEN)
	
	# 或让系统先处理动画系统，令它无法在本帧内完成销毁动作。
	#change_scene(LOGO_SCREEN, "DarkFade")
	
	change_scene.call_deferred(LOGO_SCREEN, "DarkFade")

func change_scene(new_scene: PackedScene, trans_anim: String = '') -> void:
	if not trans_anim.is_empty():
		reset_color_rect(trans_anim)
		animation_player.play(trans_anim)
	
	get_tree().change_scene_to_packed(new_scene)
	last_trans_anim = trans_anim

func get_last_trans_anim_duration() -> float:
	if last_trans_anim.is_empty():
		return 0.0
	
	return animation_player.get_animation(last_trans_anim).length

# 重置color_rect（前面的动画将透明度设为了0）
func reset_color_rect(anim) -> void:
	match anim:
		"DarkFade":
			color_rect.color = color_dark
		"LightFade":
			color_rect.color = color_light
		"ResetLevelFade":
			color_rect.color = color_dark
