extends Interactable

@export var heal_amount: float = 25.0
@export var uses: int = 1

func _ready():
    interaction_text = "Drink Coffee (%d uses)" % uses

func handle_interaction(player: PlayerController):
    if uses <= 0:
        return
    
    player.heal(heal_amount)
    uses -= 1
    $AnimationPlayer.play("drink")
    
    if uses > 0:
        interaction_text = "Drink Coffee (%d uses)" % uses
    else:
        queue_free()
