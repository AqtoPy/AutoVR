var is_aiming: bool = false

func _input(event):
    if event.is_action_pressed("aim") && current_weapon:
        toggle_aim()

func toggle_aim():
    is_aiming = !is_aiming
    current_weapon.toggle_aim()
    
    if is_aiming:
        $Camera.field_of_view = lerp($Camera.field_of_view, 55, 0.2)
        $Hands.position = Vector3(0.2, -0.3, -0.4)
    else:
        $Camera.field_of_view = lerp($Camera.field_of_view, 75, 0.2)
        $Hands.position = Vector3(0.4, -0.5, -0.6)
    
    $Tween.interpolate_property($Camera, "field_of_view", 
        $Camera.field_of_view, target_fov, 0.3)
