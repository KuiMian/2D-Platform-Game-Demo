extends State
class_name PlayerState


@export var AUTO_PLAY := true

var actor: Player

func Enter() -> void:
	super.Enter()
	
	## 进入状态自动播放相应动画
	#if AUTO_PLAY:
		#actor = get_actor()
		#actor.animation_player.play(self.name.replace(prefix, "").to_lower())
