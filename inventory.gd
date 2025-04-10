extends CanvasLayer

const SLOTS = 6
var items: Array = []
var selected_slot: int = 0

@onready var slots = $PanelContainer/GridContainer.get_children()

func _ready():
    for i in SLOTS:
        items.append(null)
    update_ui()

func add_item(item: RigidBody3D):
    for i in SLOTS:
        if items[i] == null:
            items[i] = item
            item.visible = false
            item.collision_layer = 0
            update_ui()
            return

func remove_item(slot: int):
    if items[slot]:
        items[slot].queue_free()
        items[slot] = null
        update_ui()

func update_ui():
    for i in SLOTS:
        if items[i]:
            slots[i].texture = items[i].icon
        else:
            slots[i].texture = null

func _input(event):
    if event.is_action_pressed("slot_next"):
        selected_slot = wrapi(selected_slot + 1, 0, SLOTS)
    elif event.is_action_pressed("slot_prev"):
        selected_slot = wrapi(selected_slot - 1, 0, SLOTS)
    elif event.is_action_pressed("use_item"):
        use_selected_item()

func use_selected_item():
    if items[selected_slot]:
        var item = items[selected_slot]
        items[selected_slot] = null
        item.global_transform = $Player/Hands/RightHand.global_transform
        item.visible = true
        item.collision_layer = 1
        item.apply_impulse(Vector3(0, 0, -10))
        update_ui()
