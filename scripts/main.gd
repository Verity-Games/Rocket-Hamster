extends Node2D

const planePath = preload("res://scenes/plane.tscn")
const ham = preload("res://scenes/hamster.tscn")
const hud = preload("res://scenes/HUD.tscn")

var planeGen = true
var xOff = 0
var yOff = 0
var hasEnteredZone1 = false
var hasEnteredZone2 = false
var hasEnteredZone3 = false
var hasEnteredZone4 = false

onready var planes = get_tree().get_nodes_in_group("planes")
onready var timer = $planeSpawn
onready var player = $AnimationPlayer
onready var hover = $hover

func _ready():
	HUD.vis()
	HamsterInfo.alive = true
	HUD.height = 0
	hover.play()

func _process(delta):
	HUD.left = round(timer.time_left)
	if HUD.height >= 500 and HUD.height <= 1000 and not hasEnteredZone1:
		hasEnteredZone1 = true
		changeColor(false)
	elif HUD.height >= 1000 and HUD.height <= 1500 and not hasEnteredZone2:
		hasEnteredZone2 = true
		changeColor(false)
	elif HUD.height >= 1500 and HUD.height <= 2000 and not hasEnteredZone3:
		hasEnteredZone3 = true
		changeColor(false)
	elif HUD.height >= 2000 and not hasEnteredZone4:
		hasEnteredZone4 = true
		changeColor(false)

func spawnTime():
	randomize()
	timer.wait_time = rand_range(10, 20)
	var rand = randi() % 1000
	var place = randi() % 2
	var inst = planePath.instance()

	inst.name = 'plane%s' % str(randi() % 100000)
	inst.add_to_group("planes")
	self.add_child(inst, true)

	if inst.velocity >= Vector2.ZERO:
		inst.position = Vector2(HamsterInfo.posx + rand_range(-400, 0), HamsterInfo.posy + rand_range(-1000, -1300))
	elif inst.velocity <= Vector2.ZERO:
		inst.position = Vector2(HamsterInfo.posx + rand_range(400, 0), HamsterInfo.posy + rand_range(-1000, -1300))
	
	HUD.planex = round(inst.position.x)
	HUD.planey = round(inst.position.y)

func changeColor(lighter : bool):
	if lighter:
		if HUD.height >= 500 and HUD.height <= 1000 and hasEnteredZone1:
			player.play_backwards("darker1")
		elif HUD.height >= 1000 and HUD.height <= 1500 and hasEnteredZone2:
			player.play_backwards("darker2")
		elif HUD.height >= 1500 and HUD.height <= 2000 and hasEnteredZone3:
			player.play_backwards("darker3")
		elif HUD.height >= 2000 and hasEnteredZone4:
			player.play_backwards("darkest")
	else:
		if HUD.height >= 500 and HUD.height <= 1000 and hasEnteredZone1:
			player.play("darker1")
		elif HUD.height >= 1000 and HUD.height <= 1500 and hasEnteredZone2:
			player.play("darker2")
		elif HUD.height >= 1500 and HUD.height <= 2000 and hasEnteredZone3:
			player.play("darker3")
		elif HUD.height >= 2000 and hasEnteredZone4:
			player.play("darkest")

func animationFinished(animName:String):
	if animName == "darker1" and hasEnteredZone1:
		player.stop()
	elif animName == "darker2" and hasEnteredZone2:
		player.stop()
	elif animName == "darker3" and hasEnteredZone3:
		player.stop()
	elif animName == "darkest" and hasEnteredZone4:
		player.stop()


func onTimeout():
	for plane in planes:
		plane.queue_free()


func hoverDone(animName:String):
	if animName == "hover":
		hover.play()