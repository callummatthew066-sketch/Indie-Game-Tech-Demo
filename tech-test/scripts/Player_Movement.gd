extends CharacterBody3D
@onready var camera_mount: Node3D = $Camera_mount
@onready var visuals: Node3D = $Visuals
@onready var animation_player: AnimationPlayer = $"Visuals/X Bot/AnimationPlayer"


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENS_HORIZONTAL = 0.5
const SENS_VERTICAL = 0.5
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS_HORIZONTAL))
		visuals.rotate_y((deg_to_rad(event.relative.x*SENS_HORIZONTAL)))
		camera_mount.rotate_x(deg_to_rad(event.relative.y * SENS_VERTICAL))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-40), deg_to_rad(55))
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		visuals.look_at((visuals.global_position + direction))
		
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
