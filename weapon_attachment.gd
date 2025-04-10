class_name WeaponAttachment
extends Node3D

@export var mod_type: String = "barrel"
@export var stats_modifiers: Dictionary = {
    "damage_multiplier": 1.2,
    "spread": 0.8
}
@export var visual_mesh: Mesh

func apply_mod(data: Dictionary) -> Dictionary:
    for key in stats_modifiers:
        if data.has(key):
            if key == "spread":
                data[key] *= stats_modifiers[key]
            else:
                data[key] += stats_modifiers[key]
    return data

func activate():
    if mod_type == "sight":
        $CameraZoomAnim.play("zoom_in")
