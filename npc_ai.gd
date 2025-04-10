extends CharacterBody3D

enum {IDLE, PATROL, CHASE, ATTACK}
var state = IDLE
var target: Node3D
var health: float = 100.0

@export var move_speed: float = 3.0
@export var attack_range: float = 2.0

func _ready():
    $VisionCone.connect("body_entered", _on_target_spotted)
    $VisionCone.connect("body_exited", _on_target_lost)

func _physics_process(delta):
    match state:
        PATROL:
            patrol_behavior()
        CHASE:
            chase_behavior()
        ATTACK:
            attack_behavior()

func patrol_behavior():
    # Реализация патрулирования
    pass

func chase_behavior():
    var next_path_pos = $AI.get_next_path_position()
    var direction = (next_path_pos - global_position).normalized()
    velocity = direction * move_speed
    move_and_slide()

func attack_behavior():
    if global_position.distance_to(target.global_position) < attack_range:
        target.take_damage(10 * delta)

func take_damage(amount: float):
    health -= amount
    if health <= 0:
        enable_ragdoll()

func enable_ragdoll():
    $CollisionShape.disabled = true
    set_physics_process(false)
    # Активация физики для всех костей скелета

func _on_target_spotted(body):
    if body.is_in_group("player"):
        target = body
        state = CHASE

func _on_target_lost(body):
    if body == target:
        state = PATROL
