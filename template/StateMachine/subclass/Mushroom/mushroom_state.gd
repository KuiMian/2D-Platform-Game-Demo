extends State
class_name MushroomState


@export var AUTO_PLAY := true

var actor: Mushroom


func Enter() -> void:
	super.Enter()
	
	## 进入状态自动播放相应动画
	#if AUTO_PLAY:
		#actor.animation_player.play(self.name.replace(prefix, "").to_lower())
