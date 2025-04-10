extends Node3D

var target_item: RigidBody3D = null
var is_grabbing: bool = false

func _process(delta):
    if target_item and is_grabbing:
        var target_pos = $RightHand.global_transform.origin
        target_item.global_transform.origin = target_pos.lerp(target_item.global_transform.origin, 0.2)
        target_item.rotation = $RightHand.global_transform.basis.get_rotation_quaternion()

func grab_item(item: RigidBody3D):
    target_item = item
    is_grabbing = true
    $AnimationPlayer.play("grab")
    target_item.collision_layer = 2

func release_item():
    is_grabbing = false
    $AnimationPlayer.play("release")
    if target_item:
        target_item.collision_layer = 1
        target_item = null
