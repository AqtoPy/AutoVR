extends Interactable

@export var push_force: float = 50.0
@export var max_speed: float = 5.0

var is_being_pushed: bool = false
var pusher: PlayerController = null

func _physics_process(delta):
    if is_being_pushed && pusher:
        var dir = pusher.global_transform.basis.z
        var force = dir * push_force
        apply_central_force(force)
        
        if linear_velocity.length() > max_speed:
            linear_velocity = linear_velocity.normalized() * max_speed

func handle_interaction(player: PlayerController):
    if is_being_pushed:
        stop_pushing()
    else:
        start_pushing(player)

func start_pushing(player: PlayerController):
    is_being_pushed = true
    pusher = player
    interaction_text = "Stop Pushing"
    player.movement_speed *= 0.7
    $PushSound.play()

func stop_pushing():
    is_being_pushed = false
    pusher.movement_speed /= 0.7
    pusher = null
    interaction_text = "Push Cart"
    $PushSound.stop()

func _on_body_entered(body):
    if body != pusher:
        $CollisionSound.play()
