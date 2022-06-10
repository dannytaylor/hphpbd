extends KinematicBody


const MOVE_SPEED = 12
const JUMP_FORCE = 24
const GRAVITY = 80
const MAX_Y_SPEED = 60
const MAX_X_SPEED = 30
var velocity = Vector2(0,0)
var facing_right = true

onready var anim_player = $Sprite
onready var respawn_point = get_node("../RespawnPoint")
onready var bib_point = get_node("../BIBPoint")
onready var world = get_tree().get_root().get_node("World")
onready var boulderbox = get_tree().get_root().get_node("World/boulder/boulderbox")
const jaunt_trail_scene = preload("jaunt_trail.tscn")
const bib_instance = preload("bib_instance.tscn")

# sfx
onready var sfx_jaunt = $sfx/jaunt
onready var sfx_jump = $sfx/jump
onready var sfx_cast = $sfx/cast
onready var sfx_punch = $sfx/punch

var jaunt_reset = 0.4
var jaunt_timer = jaunt_reset

var jaunt_lock_reset = 0.15
var jaunt_lock = jaunt_lock_reset
var attack_lock_reset = 0.4
var attack_lock = attack_lock_reset

func _ready():
	anim_player.play("idle")
	respawn_point.add_child(jaunt_trail_scene.instance())

func _process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1

		
	move_and_slide(Vector3(move_dir * MOVE_SPEED, velocity.y, 0), Vector3(0,1,0))
	
	var just_jumped = false
	var grounded = is_on_floor()
	var new_vel_y = velocity.y - GRAVITY * delta
	
	
#	if not grounded and velocity.y >= -0.25 and new_vel_y <= 0.0:
#		if Input.is_action_pressed("jump"):
#			new_vel_y = -0.2
	velocity.y = new_vel_y
		
	if velocity.y < -MAX_Y_SPEED:
		velocity.y = -MAX_Y_SPEED
		
	if grounded:
		velocity.y = -0.1
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_FORCE
			just_jumped = true		
			sfx_jump.play()
			anim_player.play("jump_up")
	if is_on_ceiling():
		velocity.y = 0
	
	
	if move_dir < 0 and facing_right:
		flip()
	if move_dir > 0 and !facing_right:
		flip()
	
	# jaunt to top
	if translation.y < -15:
		if jaunt_timer == jaunt_reset:
			sfx_jaunt.play()
		jaunt_timer -= delta
		if jaunt_timer <= 0:
			translation = respawn_point.transform.origin
			
			respawn_point.add_child(jaunt_trail_scene.instance())
			
			jaunt_timer = jaunt_reset
			anim_player.play("jaunt")
			jaunt_lock = jaunt_lock_reset
		
	if jaunt_lock >= 0:
		jaunt_lock -= delta
	if attack_lock >= 0:
		attack_lock -= delta
		if attack_lock <= attack_lock_reset/8:
			$punchbox.translation.z = -10
		
		
			
	if jaunt_lock <= 0 and attack_lock <= 0:
		if grounded and velocity.y <= 0:
			if move_dir == 0:
				anim_player.play("idle")
			else:
				if anim_player.animation != 'run':
					anim_player.play("run")
		elif velocity.y < -3.0:
			anim_player.play("jump_down")

		if Input.is_action_pressed("punch"):
			anim_player.play("punch")
			attack_lock = attack_lock_reset
			$punchbox.translation.z = -10
			$punchbox.translation.z = 0.0
			sfx_punch.play()
		if Input.is_action_pressed("cast") and not sfx_cast.playing:
			anim_player.play("cast")
			attack_lock = attack_lock_reset+0.2
			spawn_bib()

func flip():
	scale.x *= -1
	facing_right = !facing_right
	
func spawn_bib():
	
	sfx_cast.play()
	yield(get_tree().create_timer(0.2), "timeout")
	bib_point.transform.origin = transform.origin
	bib_point.scale.x = scale.x
	bib_point.add_child(bib_instance.instance())
	

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)


func _on_punchbox_area_entered(area):
	if area == boulderbox:
		world.take_damage(1)
	
		
