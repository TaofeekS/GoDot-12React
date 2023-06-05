extends ColorRect

signal fade_out_finished

export var fadeInOutTime: float = 1

onready var tween: Tween = $Tween

func _ready():
	color.a = 1
	fade_in()


func fade_out():
	tween.interpolate_property(self, "color:a", color.a, 1, fadeInOutTime, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()


func fade_in():
	tween.interpolate_property(self, "color:a", color.a, 0, fadeInOutTime, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()


func _on_Tween_tween_all_completed():
	if color.a == 1:
		emit_signal("fade_out_finished")
