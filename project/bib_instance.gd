extends Spatial



export(float) var life = 2.0
export(float) var speed = 24

onready var boulderbox = get_tree().get_root().get_node("World/boulder/boulderbox")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life -= delta
	translation.x += delta*speed
	if life  <= 0.0:
		die()
		
func _ready():
	speed *= scale.x
	
func die():
	queue_free()

func _on_bib_area_area_entered(area):
	print(area)
	if area == boulderbox:
		speed = 0
		life = 0.4
		$Sprite.play("hit")
		get_tree().get_root().get_node("World").take_damage(2)
