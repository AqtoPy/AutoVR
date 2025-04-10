class_name Interactable
extends Node3D

@export_category("Interaction Settings")
@export var interaction_text: String = "Interact"
@export var interaction_icon: Texture2D
@export var requires_item: String = ""
@export var consume_item: bool = false

@export_category("Visuals")
@export var highlight_material: StandardMaterial3D
var original_materials: Array = []

@export_category("Sound Effects")
@export var interact_sound: AudioStream
@export var highlight_sound: AudioStream

var is_highlighted: bool = false
var interaction_cooldown: bool = false

func _ready():
    if $CollisionShape3D:
        original_materials = $Mesh.get_surface_override_materials()
    
    add_to_group("interactables")

func show_prompt():
    if interaction_cooldown:
        return
    GameUI.show_interaction_prompt(interaction_text, interaction_icon)

func hide_prompt():
    GameUI.hide_interaction_prompt()

func highlight(enable: bool):
    if enable == is_highlighted:
        return
    
    is_highlighted = enable
    if enable && highlight_sound:
        $AudioStreamPlayer3D.stream = highlight_sound
        $AudioStreamPlayer3D.play()
    
    if $Mesh && highlight_material:
        if enable:
            for i in $Mesh.get_surface_override_material_count():
                $Mesh.set_surface_override_material(i, highlight_material)
        else:
            for i in original_materials.size():
                $Mesh.set_surface_override_material(i, original_materials[i])

func interact(player: PlayerController):
    if interaction_cooldown:
        return
    
    if requires_item != "" && !player.inventory.has_item(requires_item):
        GameUI.show_message("You need %s to interact!" % requires_item)
        return
    
    if consume_item && requires_item != "":
        player.inventory.remove_item(requires_item)
    
    if interact_sound:
        $AudioStreamPlayer3D.stream = interact_sound
        $AudioStreamPlayer3D.play()
    
    handle_interaction(player)
    start_cooldown(1.0)

func handle_interaction(player: PlayerController):
    pass # Для переопределения в дочерних классах

func start_cooldown(time: float):
    interaction_cooldown = true
    await get_tree().create_timer(time).timeout
    interaction_cooldown = false
