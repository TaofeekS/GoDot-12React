extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.frame = 0
	yield(get_tree().create_timer(1), "timeout")
	$AnimatedSprite.play()
