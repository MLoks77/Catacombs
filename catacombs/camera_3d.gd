extends Camera3D

@export var sensitivity: float = 0.1
@export var max_look_angle: float = 90  # Limite max en degrés
@export var head_bobbing_speed: float = 4.0  # Vitesse du bobbing
@export var head_bobbing_amplitude: float = 0.1  # Amplitude du mouvement de la tête

var vertical_angle: float = 0.0  # Stocke l'angle vertical
var horizontal_angle: float = 0.0  # Stocke l'angle horizontal
var player: CharacterBody3D
var timer: float = 0.0  # Timer pour contrôler l'oscillation

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player = get_parent()  # Récupère le joueur parent (CharacterBody3D)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var rotation_x = -event.relative.y * sensitivity
		var rotation_y = -event.relative.x * sensitivity

		# Mise à jour des angles
		horizontal_angle += rotation_y
		vertical_angle = clamp(vertical_angle + rotation_x, -max_look_angle, max_look_angle)

func _process(delta):
	# Applique la rotation horizontale du joueur
	get_parent().rotation.y = deg_to_rad(horizontal_angle)
	# Applique la rotation verticale de la caméra
	rotation_degrees.x = vertical_angle

	# Vérifie si le joueur est en mouvement
	var is_moving = player.velocity.length() > 0  # Utilise la vitesse du joueur pour détecter s'il se déplace

	if is_moving:
		# Augmente le timer lorsqu'il se déplace
		timer += head_bobbing_speed * delta
		# Crée un mouvement de haut en bas avec une sinusoïde
		var bobbing = sin(timer) * head_bobbing_amplitude
		# Applique le mouvement de tête à la caméra
		global_position.y = player.global_position.y + bobbing
	else:
		# Si le joueur ne bouge pas, la caméra est stable
		global_position.y = player.global_position.y
