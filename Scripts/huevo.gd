extends Area3D

signal collectado(valor: int)

var valor: int = 1
var velocidad_rotacion: float = 4.0
var gravedad: float = 9.8
var velocidad_caida: float = 0.0
var altura_inicial: float = 5.0
var collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	position.y = altura_inicial

func _process(delta: float) -> void:
	if not collected:
		velocidad_caida += gravedad * delta
		position.y -= velocidad_caida * delta
		rotate_y(velocidad_rotacion * delta)
		
		if position.y <= 0:
			position.y = 0
			velocidad_caida = 0

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not collected:
		collected = true
		print("Huevo colisionado! Llamando collect_egg en: ", body.name)
		if body.has_method("collect_egg"):
			body.collect_egg()
		emit_signal("collectado", valor)
		set_deferred("visible", false)
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
