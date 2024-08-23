extends Area2D

signal hit

@export var speed = 400 # px/sec
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		vel.x = 1
	if Input.is_action_pressed("move_left"):
		vel.x = -1
	if Input.is_action_pressed("move_up"):
		vel.y = 1
	if Input.is_action_pressed("move_down"):
		vel.y = -1
	
	if vel.length() > 0:
		vel = vel.normalized() * speed # this prevents the player from moving faster then normal when moving diagonally
		$AnimatedSprite2D.play()
	else:
		get_node("AnimatedSprite2D").stop()
		
	if vel.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = vel.x < 0
		$AnimatedSprite2D.flip_v = false
	if vel.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_v = vel.y > 0
		
	position += vel * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	# 
	# We need to disable the player's collision so that we don't trigger the hit signal more than once.
	#
	# Disabling the area's collision shape can cause an error if it happens in the middle of the 
	# engine's collision processing. Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)


func start(position) -> void:
	position = position
	show()
	$CollisionShape2D.disabled = false
