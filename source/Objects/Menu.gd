extends Node2D


var pulse = 10
var up = false

var prompt_vel = 0

var global


func _ready():
    global = get_node('/root/global')
    $Highscore.text = 'HIGHSCORE: %d' % get_node('/root/global').highscore
    

func _process(delta):
    # title
    if up:
        $Title.position.y -= pulse / 40
        pulse += 0.025
        if pulse >= 12:
            up = false
    else:
        $Title.position.y += pulse / 40
        pulse -= 0.025
        if pulse <= 10:
            up = true
    $Title.scale = Vector2(pulse, pulse)
    $Particles2D.position.y = $Title.position.y
    
    # prompt
    if $Prompt.rect_position.y > 390:
        $Prompt.rect_position.y = 390
        prompt_vel = -1
    else:
        $Prompt.rect_position.y += prompt_vel
        prompt_vel += 0.15
        
    if global.muted:
        $Mute.text = 'UNMUTE (M)'
    else:
        $Mute.text = 'MUTE (M)'
    
    # continue
    if Input.is_action_just_pressed('jump'):
        $sfxStartGame.play()
        $Fade.reverse()
        $Prompt.modulate.r = 255
        $Prompt.modulate.g = 255
        $Prompt.modulate.b = 255

func _on_sfxStartGame_finished():
    get_tree().change_scene('res://Objects/Game.tscn')
