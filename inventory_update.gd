var weapon_skins: Dictionary = {} # skin_id: texture

func apply_skin_to_weapon(skin_id: String, weapon: Weapon):
    if weapon_skins.has(skin_id):
        weapon.skin_material.albedo_texture = weapon_skins[skin_id]

func unlock_skin(skin_id: String, texture: Texture2D):
    weapon_skins[skin_id] = texture
    GameUI.show_unlock_message("New skin unlocked: %s" % skin_id)
