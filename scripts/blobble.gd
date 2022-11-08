extends KinematicBody2D

onready var player = $AnimationPlayer
onready var path = $Path2D/PathFollow2D

var playbackSpeed = 1

func _ready():
    #player.play()
	pass

func animationFinished(animName:String):
    #if animName == "hoer":
    #    player.play("hoer")
	pass