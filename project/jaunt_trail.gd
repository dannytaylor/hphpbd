extends Spatial



export(float) var life = 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	life -= delta
	if life  <= 0.0:
		die()
	
func die():
	queue_free()
