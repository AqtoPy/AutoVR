class_name Weapon
extends RigidBody3D

@export var damage: float = 25.0
@export var fire_rate: float = 0.2
@export var ammo: int = 30
@export var max_ammo: int = 90

var is_equipped: bool = false

func primary_fire():
    if ammo > 0 and $FireTimer.is_stopped():
        ammo -= 1
        $MuzzleFlash.restart()
        $AudioStreamPlayer3D.play()
        # Реализация выстрела

func reload():
    var reload_amount = min(max_ammo, ammo + 30)
    ammo = reload_amount

func _on_picked_up():
    freeze = true
    collision_layer = 0

func _on_dropped():
    freeze = false
    collision_layer = 1
