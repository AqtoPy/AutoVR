extends CanvasLayer

@onready var vr_overlay = $ColorRect

func _ready():
    var material = ShaderMaterial.new()
    material.shader = load("res://vr_effect.gdshader")
    vr_overlay.material = material

func _process(delta):
    var distortion = sin(Time.get_ticks_msec() * 0.001) * 0.02
vr_overlay.material.set_shader_parameter("distortion", distortion)
