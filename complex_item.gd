extends Interactable

@export var required_item: String = ""
@export var transformed_item: PackedScene

func interact(player: PlayerController):
    if player.inventory.has_item(required_item):
        var new_item = transformed_item.instantiate()
        get_parent().add_child(new_item)
        new_item.global_transform = global_transform
        player.inventory.remove_item(required_item)
        queue_free()
