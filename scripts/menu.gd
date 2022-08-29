extends Control

onready var player = $nightDay

func _ready():
	HUD.visible = false

func onFinished(anim_name:String):
	player.play("light-dark-light")


func _onPlay():
	get_tree().change_scene("res://scenes/main.tscn")

func _onSettings():
	print("Not Available")


func _onExit():
	get_tree().quit()
