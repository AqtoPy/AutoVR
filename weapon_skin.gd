class_name WeaponSkin
extends WeaponAttachment

@export var skin_textures: Array[Texture2D]
@export var decal_positions: Array[Vector3]
@export var sticker_scale: float = 0.1

var current_decal_index: int = 0

func apply_skin(weapon: MeshInstance3D):
    var material = weapon.get_active_material(0).duplicate()
    material.albedo_texture = skin_textures[current_decal_index]
    weapon.set_surface_override_material(0, material)

func add_sticker(position: Vector3, texture: Texture2D):
    var decal = Decal.new()
    decal.texture = texture
    decal.size = Vector3(sticker_scale, sticker_scale, 0.01)
    decal.position = position
    add_child(decal)
