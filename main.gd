extends Node

@export var enemy_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	get_tree().call_group("enemies", "queue_free")


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$HUD.show_message("Hmm")
	$Music.play()
	$StartTimer.start()


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$EnemyTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = enemy_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	
	var vel = Vector2(randf_range(150, 250), 0)
	enemy.linear_velocity = vel.rotated(direction)
	
	add_child(enemy)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
