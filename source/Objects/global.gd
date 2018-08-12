extends Node

var highscore = 0
var muted = false


func _process(delta):
    if Input.is_action_just_pressed('mute'):
        muted = not muted


