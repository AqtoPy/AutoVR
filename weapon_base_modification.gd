extends RigidBody3D
class_name Weapon

# Добавляем новые свойства
@export var allowed_ammo_types: Array[AmmoType] = [AmmoType.PISTOL]
@export var attachment_points: Dictionary = {
    "barrel": null,
    "sight": null,
    "magazine": null,
    "grip": null
}

var current_ammo_type: AmmoType = AmmoType.PISTOL
var attachments: Dictionary = {}
var aim_mode: bool = false

func _ready():
    update_weapon_stats()

func update_weapon_stats():
    # Рассчет итоговых характеристик с учетом модификаций
    var base_data = AMMO_DATA[current_ammo_type].duplicate()
    
    for attachment in attachments.values():
        if attachment.has_method("apply_mod"):
            base_data = attachment.apply_mod(base_data)
    
    $RayCast.position = Vector3(0, 0, -barrel_length)
    $RayCast.target_position = Vector3(0, 0, -100)

func toggle_aim():
    aim_mode = !aim_mode
    $AnimationPlayer.play("aim_toggle")
    if aim_mode && attachments.has("sight"):
        attachments["sight"].activate()

func fire():
    var fire_data = calculate_fire_data()
    if fire_data:
        spawn_projectile(fire_data)
        $MuzzleFlash.restart()

func calculate_fire_data():
    var data = AMMO_DATA[current_ammo_type].duplicate()
    data.position = $RayCast.global_transform.origin
    data.direction = -global_transform.basis.z
    
    if aim_mode:
        data.spread *= 0.2
        if attachments.get("sight"):
            data.spread *= attachments["sight"].zoom_factor
    
    return data

func attach_mod(attachment: WeaponAttachment, slot: String):
    if attachment_points.has(slot):
        if attachments.has(slot):
            detach_mod(slot)
        attachments[slot] = attachment
        attachment.global_transform = attachment_points[slot].global_transform
        attachment.reparent(self)
        update_weapon_stats()

func detach_mod(slot: String):
    if attachments.has(slot):
        attachments[slot].queue_free()
        attachments.erase(slot)
        update_weapon_stats()
