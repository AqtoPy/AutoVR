# bullet.gd
extends RayCast3D

func _ready():
    var result = get_collision()
    if result:
        if result.collider.has_method("take_damage"):
            result.collider.take_damage(damage)
        create_impact_effect(result.position)
