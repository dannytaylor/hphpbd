extends Camera

var max_x = -20
var max_y = 20
var speed = 2

var destroyed = false

onready var target = get_node("../Player")
onready var target_end = get_node("../BoulderPoint")

# Called when the node enters the scene tree for the first time.
func _ready():

	set_process(true)
	set_process_input(true)

func destroyed():
	destroyed = true
	max_x = 0

func _process(delta):
	
	if destroyed:
		global_transform.origin = lerp(global_transform.origin, target_end.global_transform.origin, delta*speed)

	var target_position = target.transform.origin
	var new_transform = transform.looking_at(target_position, Vector3.UP)
	transform  = transform.interpolate_with(new_transform, speed * delta)
	
	
	rotation_degrees.x = max(rotation_degrees.x,max_x)
	rotation_degrees.y = max(rotation_degrees.y,-max_y)
	rotation_degrees.y = min(rotation_degrees.y,max_y)
	rotation_degrees.z = 0
