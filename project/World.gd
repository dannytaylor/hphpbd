extends Spatial


export(float) var  boulder_health = 12
var destroyed = false


func _ready():
	$GridMap.visible = false

func take_damage(dmg):
	boulder_health -= dmg
	print("ouch ", dmg, ", ", boulder_health)
	
func destroy_boulder():
	destroyed = true
	get_node("boulder/Destruction").destroy()
	$Camera.destroyed()
	$Player.respawn_point.transform.origin.x = 0
	$Player/sfx/break.play()
	$UI/bdayhats.emitting = true
	$Player/Sprite/crown.visible = true

func _process(delta):
	if boulder_health <= 0 and not destroyed:
		destroy_boulder()
	
	
func _input(event: InputEvent) -> void:
	#if Input.is_action_pressed("ui_accept") and not destroyed:
	#	destroy_boulder()
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://World.tscn")
