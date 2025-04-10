enum AmmoType {
    PISTOL,
    RIFLE,
    SHOTGUN,
    ENERGY
}

const AMMO_DATA = {
    AmmoType.PISTOL: {
        "damage_multiplier": 1.0,
        "speed": 120,
        "penetration": 1,
        "icon": preload("res://icons/pistol_ammo.png")
    },
    AmmoType.RIFLE: {
        "damage_multiplier": 1.5,
        "speed": 200,
        "penetration": 3,
        "icon": preload("res://icons/rifle_ammo.png")
    },
    AmmoType.SHOTGUN: {
        "damage_multiplier": 2.0,
        "speed": 80,
        "pellet_count": 8,
        "icon": preload("res://icons/shotgun_ammo.png")
    },
    AmmoType.ENERGY: {
        "damage_multiplier": 0.8,
        "speed": 300,
        "chain_lightning": true,
        "icon": preload("res://icons/energy_ammo.png")
    }
}
