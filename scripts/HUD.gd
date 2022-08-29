extends Control

onready var label = $CanvasLayer/RichTextLabel
onready var dbLabel = $CanvasLayer/Label
onready var retry = $CanvasLayer/retry
onready var main = $CanvasLayer/mainMenu
onready var quit = $CanvasLayer/quit
onready var died = $CanvasLayer/died

var high = 0
var height = 0
var inc = .3
var toggled = false
var planex
var planey
var ham = preload("res://scenes/hamster.tscn")
var try = false
var left

func _ready():
	print("HUD:" + str(visible))
	label.bbcode_enabled = true
	label.text = str(height)
	label.visible = false
	dbLabel.visible = false
	retry.visible = false
	main.visible = false
	quit.visible = false
	died.visible = false

func change(var lean):
	if lean:
		height += inc
		label.bbcode_text = "[center]%s[/center]" % str(floor(height))
	else:
		height -= inc
		label.bbcode_text = "[center]%s[/center]" % str(floor(height))

	if height < 0:
		height = 0

	if height >= 300:
		label.bbcode_text = "[center][shake level = 5]%s[/shake][/center]" % str(floor(height))

	if high <= height:
		high = height

func vis():
	yield(get_tree().create_timer(0.1), "timeout")
	label.visible = true
	retry.visible = false
	main.visible = false
	quit.visible = false
	died.visible = false

func hid():
	yield(get_tree().create_timer(0.1), "timeout")
	label.visible = false
	retry.visible = false
	main.visible = false
	quit.visible = false
	died.visible = false

func dead():
	label.visible = false
	retry.visible = true
	main.visible = true
	quit.visible = true
	died.visible = true
	died.bbcode_enabled = true
	died.bbcode_text = """[center]
	You Died
	[wave level = 10]
	Highscore: %s
	[/wave]
	[/center]""" % round(high)

func _process(delta):
	if Input.is_action_just_pressed("db") and toggled == false:
		dbLabel.visible = true
		toggled = true
	elif Input.is_action_just_pressed("db") and toggled == true:
		dbLabel.visible = false
		toggled = false

	dbLabel.text = """
	FPS: %s	  PlaneSpawn: %s
	Current Position: (%s, %s)
	Last Spawned Plane: (%s, %s)
	""" % [str(Engine.get_frames_per_second()), str(left),  HamsterInfo.posx, HamsterInfo.posy, planex, planey]


func _on_mainMenu_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")

func _retry():
	try = true
	get_tree().change_scene("res://scenes/main.tscn")

func _on_quit_pressed():
	get_tree().quit()
