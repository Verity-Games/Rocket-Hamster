extends Control

onready var player = $nightDay
onready var music = $music
onready var discord = $discordLogo

var lullaby = load("res://assets/music/hamstersLullaby.wav")
var gathering = load("res://assets/music/hamstersGathering.wav")

func _ready():
	HUD.hid()
	var rand = rand_range(1, 2)
	print(rand)
	if round(rand) == 1:
		music.stream = lullaby
		music.play()
	elif round(rand) == 2:
		music.stream = gathering
		music.play()

func onFinished(anim_name:String):
	player.play("light-dark-light")


func _onPlay():
	get_tree().change_scene("res://scenes/main.tscn")

func _onSettings():
	print("Not Available")

func _onExit():
	get_tree().quit()

func musicFinished() -> void:
	var rand = rand_range(1, 2)
	print(rand)
	if round(rand) == 1:
		music.stream = lullaby
		music.play()
	elif round(rand) == 2:
		music.stream = gathering
		music.play()


func discordPressed():
	OS.shell_open("https://discord.gg/w7CVGfVeDZ")
	discord.modulate = Color(150, 150, 150, 255)


func discordNotPressed():
	discord.modulate = Color(195, 195, 195, 255)
