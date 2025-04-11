extends CharacterBody3D

@export var grab_distance := 2.0
@export var throw_force := 15.0

var current_interactable: Interactable
var grabbed_object: Interactable

func _physics_process(delta):
    var space_state = get_world_3d().direct_space_state
    var query = PhysicsRayQueryParameters3D.create(
        $Camera3D.global_transform.origin,
        $Camera3D.global_transform.origin + $Camera3D.global_transform.basis.z * -grab_distance
    )
    
    var result = space_state.intersect_ray(query)
    
    if result:
        current_interactable = result.collider as Interactable
    else:
        current_interactable = null

func _input(event):
    # Захват/отпускание
    if event.is_action_pressed("grab"):
        if current_interactable and not grabbed_object:
            grabbed_object = current_interactable
            grabbed_object.grab($HandPosition)
            
        elif grabbed_object:
            var throw_dir = -$Camera3D.global_transform.basis.z
            grabbed_object.release(throw_dir * throw_force)
            grabbed_object = null
    
    # Взаимодействие
    if event.is_action_pressed("interact") and current_interactable:
        current_interactable.interact()
