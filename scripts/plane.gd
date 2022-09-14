extends KinematicBody2D

var velocity = Vector2.ZERO
var planeGen = true
var inp = Vector2()

const speed = 50
const negSpeed = -50
const MAX = 100
const SPEED = 500

#onready var cast = $RayCast2D
#onready var cast2 = $RayCast2D2
#onready var cast3 = $RayCast2D3
#onready var cast4 = $RayCast2D4
onready var sprite = $AnimatedSprite
onready var area = $death
#onready var vis = $VisibilityNotifier2D

func _ready():
	var rand = randi() % 2
	if rand == 0:
		inp = Vector2(speed, 0)
		sprite.flip_h = true
	elif rand == 1:
		inp = Vector2(negSpeed, 0)
		sprite.flip_h = false


func _process(delta):
	velocity = inp * SPEED * delta

	velocity.clamped(MAX * delta)

	move_and_slide(velocity)
	
	#if cast.is_colliding() or cast2.is_colliding() or cast3.is_colliding() or cast4.is_colliding() and HamsterInfo.alive:
	#	print("collide")
	#	HamsterInfo.alive = false

	if HamsterInfo.alive == false:
		queue_free()

func _deathArea(body:Node):
	if body.get_name() == "hamster":
		#Updater.deathCause = "Plane"
		#Updater.updateCOD(Updater.deathCause)
		HamsterInfo.alive = false
		#Achievements.giveAchievement("That Hurts!")
		#Achievements.firstDeath = false

func clearPlanes():
	queue_free()
