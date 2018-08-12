extends Area2D

var mc = 1.0
var up = true

func _physics_process(delta):
    if up:
        mc += 0.04
        if mc >= 3.0:
            up = false
    else:
        mc -= 0.025
        if mc <= 1.0:
            up = true
            
    var s = 1 + mc / 10
    scale = Vector2(s, s)


func _on_Blackhole_area_entered( area ):
    if area.is_in_group('destructable'):
        $AudioStreamPlayer.play()
