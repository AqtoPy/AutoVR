extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_pivot: Node3D
var camera: Camera3D
var current_grab: RigidBody3D = null

func _ready():
    camera_pivot = $CameraPivot
    camera = $CameraPivot/Camera3D
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
    if event is InputEventMouseMotion:
        camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
        rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
        camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -1.5, 1.5)
    
    if Input.is_action_just_pressed("grab"):
        try_grab_object()
    
    if Input.is_action_just_released("grab") and current_grab:
        release_object()

func _physics_process(delta):
    # Movement
    var input_dir = Input.get_vector("left", "right", "forward", "backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
    
    velocity.y -= gravity * delta
    move_and_slide()
    
    # Object grabbing
    if current_grab:
        current_grab.global_transform.origin = camera.global_transform.origin + camera.global_transform.basis.z * -1

func try_grab_object():
    var ray_length = 3.0
    var from = camera.global_transform.origin
    var to = from + camera.global_transform.basis.z * -ray_length
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(from, to)
    var result = space_state.intersect_ray(query)
    
    if result and result.collider is RigidBody3D:
        current_grab = result.collider
        current_grab.freeze = true

func release_object():
    current_grab.freeze = false
    current_grab.linear_velocity = camera.global_transform.basis.z * -10
    current_grab = null
