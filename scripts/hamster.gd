extends RigidBody2D

var velocity = Vector2.ZERO
var pos = get_position().y
var posy = null
var posx = null
var alive = true
var firstFlight = true

const SPEED = 15
const ACC = 250
const MAX = 400
const FRIC = 750

onready var sprite = $AnimatedSprite
onready var cast = $RayCast2D
onready var cam = $Camera2D
onready var audio = $AudioStreamPlayer
onready var wind = $wind

func _ready():
	HUD.height = 0
	yield(get_tree().create_timer(.1), "timeout")
	print("B4: %s" % HamsterInfo.alive)
	HamsterInfo.alive = true
	print("After: %s" % HamsterInfo.alive)

func _physics_process(delta):
	var inp = Vector2.ZERO

	inp.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inp.y = -Input.get_action_strength("up")
	inp = inp.normalized()

	if inp != Vector2.ZERO:
		velocity += inp * ACC * delta
		apply_central_impulse(velocity)

		velocity = velocity.clamped(MAX * delta)
	else:
		velocity = velocity.move_toward(Vector2(0, 0), FRIC * delta)
		apply_central_impulse(velocity)

	#print(velocity)

	if Input.get_action_strength("up") == 1:
		sprite.play("flying")
		if Input.get_action_strength("right") == 1:
			sprite.flip_h = false
		elif Input.get_action_strength("left") == 1:
			sprite.flip_h = true
		if Input.is_action_just_pressed("up") and audio.get_playback_position() < 6:
			audio.play()
		if audio.get_playback_position() > 6:
			audio.play(0)
	elif cast.is_colliding() and Input.get_action_strength("right") == 1:
		sprite.play("walking")
		sprite.flip_h = false
	elif cast.is_colliding() and Input.get_action_strength("left") == 1:
		sprite.play("walking")
		sprite.flip_h = true
	elif cast.is_colliding():
		sprite.play("stand still")
	else:
		sprite.play("falling")
		if Input.get_action_strength("right") == 1:
			sprite.flip_h = false
		elif Input.get_action_strength("left") == 1:
			sprite.flip_h = true
		audio.stop()

func _process(delta):
	var last = pos
	pos = get_position().y
	if pos < last:
		HUD.change(true)
		HUD.height += .00001
		HUD.high = HUD.height
	elif pos > last:
		HUD.change(false)

	if cast.is_colliding():
		HUD.height = 0

	posy = round(get_position().y)
	posx = round(get_position().x)

	HamsterInfo.posx = posx
	HamsterInfo.posy = posy
	
	if HamsterInfo.alive == false:
		die()

	wind()
	#print(get_position())
	#if HUD.height == 1000:
	#	Achievements.giveAchievement("Lightheaded yet?")
	#	Achievements.first1K = false
#
	#if HUD.height == 3000:
	#	Achievements.giveAchievement("Bound to Pass Out")
	#	Achievements.first3K = false
#
	#if HUD.height == 10000:
	#	Achievements.giveAchievement("Still Alive?")
	#	Achievements.first10K = false
	#
	#if Input.get_action_strength("up") == 1 and firstFlight:
	#	Achievements.giveAchievement("Up, Up, and Away!")
	#	firstFlight = false
	#	Achievements.firstFlight = false
	#elif not firstFlight:
	#	pass

func wind():
	if Input.is_action_just_released("up"):
		wind.play(0)
	if wind.get_playback_position() > 2:
		wind.play(0)
	else:
		wind.stop()

func _integrate_forces(state):
	rotation_degrees = 0
	$CollisionShape2D.rotation_degrees = 0

func die():
	print(HamsterInfo.alive)
	HUD.dead()
	queue_free()

func _exitCam():
	die()

func windFinished():
	if HUD.height > 100:
		wind.play()

func audioFinished() -> void:
	audio.play()
