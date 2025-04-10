# Добавляем в верхнюю часть
var inventory: Node
var hands: Node

func _ready():
    # ... предыдущий код
    inventory = $Inventory
    hands = $Hands

# Модифицируем try_grab_object
func try_grab_object():
    var ray_length = 3.0
    var from = camera.global_transform.origin
    var to = from + camera.global_transform.basis.z * -ray_length
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(from, to)
    var result = space_state.intersect_ray(query)
    
    if result:
        if result.collider is RigidBody3D:
            if Input.is_action_pressed("modifier"):
                inventory.add_item(result.collider)
            else:
                hands.grab_item(result.collider)
        elif result.collider is Interactable:
            result.collider.interact(self)

# Добавляем новые функции
func _physics_process(delta):
    # ... предыдущий код
    if Input.is_action_just_pressed("interact"):
        var interactables = $InteractionArea.get_overlapping_bodies()
        if interactables.size() > 0:
            interactables[0].interact(self)
