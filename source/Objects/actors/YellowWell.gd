extends "res://Objects/actors/Hazard.gd"

var strength = 8

func _physics_process(delta):
    move()
    
    if player_ref != null:
        shake()

func _on_PulseTimer_timeout():
    if player_ref != null and not player_ref.aerial:
        var dist_x = player_ref.position.x - position.x
        var dist_y = player_ref.position.y - position.y
        
        # calc direction of pull
        var div = max(abs(dist_x), abs(dist_y))
        dist_x = dist_x / div
        dist_y = dist_y / div
        
        # Gravitational pull
        player_ref.environment_force.x -= dist_x * -strength
        player_ref.environment_force.y -= dist_y * -strength
        
        # Pulls stronger the longer youre inside it
        strength += 0.01
        
        player_ref.emit_signal('hit')
        $sfxHit.play()
        
func _on_GravityRange_area_entered(area):
    ._on_GravityRange_area_entered(area)
    if area.name == 'Player':
        $GravityRange/sfxRumble.play()
        
func _on_GravityRange_area_exited(area):
    ._on_GravityRange_area_exited(area)
    if area.name == 'Player':
        $GravityRange/sfxRumble.stop()

func _on_GravityRange_sfx_finished():
    if player_ref != null:
        $GravityRange/sfxRumble.play()
