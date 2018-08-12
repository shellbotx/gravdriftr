extends "res://Objects/actors/Hazard.gd"


const MAX_SPEED = 0.75
var wr = null

func _ready():
    if player_ref:
        wr = weakref(player_ref)
        $sfxCry.play()


func _physics_process(delta):
    if wr != null and wr.get_ref():
        if position.x > player_ref.position.x:
            if velocity.x > -MAX_SPEED:
                velocity.x -= 0.05
        elif position.x < player_ref.position.x:
            if velocity.x < MAX_SPEED:
                velocity.x += 0.05
    move()
    shake()
