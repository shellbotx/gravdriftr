extends Area2D

const ROT = deg2rad(1)

var shake_intensity = 2

var velocity = Vector2()
var rotation_speed = 0

var player_ref = null
  
        
func move():
    position += velocity
    rotation += ROT * rotation_speed
    

func shake():
    position.x += rand_range(-1.0, 1.0) * shake_intensity
    position.y += rand_range(-1.0, 1.0) * shake_intensity
    

func _on_GravityRange_area_entered( area ):
    if area.name == 'Player':
        player_ref = area
        $GravityRange/sfxRumble.play()

func _on_GravityRange_area_exited(area):
    if area.name == 'Player':
        player_ref.environment_force.y = 0
        player_ref = null
        $GravityRange/sfxRumble.play()
        
func _on_GravityRange_sfx_finished():
    $GravityRange/sfxRumble.play()
