# Добавляем в класс
var current_pushed_object: Interactable = null

func _physics_process(delta):
    handle_pushing(delta)
    
    if current_pushed_object:
        var dir = -camera.global_transform.basis.z
        current_pushed_object.apply_central_force(dir * 100)

func handle_pushing(delta):
    if Input.is_action_just_released("interact") && current_pushed_object:
        current_pushed_object.stop_pushing()
        current_pushed_object = null

func _on_interaction_area_body_entered(body):
    if body is Interactable:
        current_interactable = body
        body.show_prompt()

func _on_interaction_area_body_exited(body):
    if body == current_interactable:
        current_interactable.hide_prompt()
        current_interactable = null
