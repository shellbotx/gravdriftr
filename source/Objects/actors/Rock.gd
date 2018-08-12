extends "res://Objects/actors/Hazard.gd"

func _physics_process(delta):
    move()

func _on_Rock_area_entered( area ):
    if area.name == 'Player' and not area.aerial:
        area.environment_force.y += 1
        area.user_force.x = 0
        
        var r = randi()%3 + 1
        if r == 1:
            $sfxExplodeA.play()
        else:
            $sfxExplodeB.play()
        
        $CollisionShape2D.disabled = true
        hide()


func _on_Timer_timeout():
    # blink
    if $Sprite.modulate.a == 0.5:
        $Sprite.modulate.a = 1
    else:
        $Sprite.modulate.a = 0.5
