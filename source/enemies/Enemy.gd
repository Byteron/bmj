extends Area2D

var spread := 0.0

var positions = []

var shots := 0

export var shots_max := 5

onready var cooldown_timer := $CooldownTimer as Timer
onready var shoot_timer := $ShootTimer as Timer

onready var tween := $Tween as Tween
onready var cannon := $Cannon

func _ready() -> void:
	var size = get_viewport_rect().size
	size.y = size.y / 2
	for i in 5:
		positions.append(Vector2(randi() % int(size.x), randi() % int(size.y)))

func _process(delta: float) -> void:
	spread += delta * 2

func shoot() -> void:
	var bullet = Instance.Bullet(cannon.global_position, -180, 1600, 5)
	bullet.shooter = self
	get_parent().add_child(bullet)
	shots += 1

func move() -> void:
	var new_position = positions[randi() % positions.size()]
	tween.interpolate_property(self, "position", position, new_position, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _on_ShootTimer_timeout() -> void:
	if shots < shots_max:
		shoot()
	else:

		cooldown_timer.start()
		shoot_timer.stop()
func _on_CooldownTimer_timeout() -> void:
	move()


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	shots = 0
	shoot_timer.start()
