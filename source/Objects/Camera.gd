extends Camera2D

var shake_duration = 0
var shake_intensity = 5

func _process(delta):
    if shake_duration != 0:
        shake_duration -= 1
        offset = Vector2(
            rand_range(-1.0, 1.0) * shake_intensity,
            rand_range(-1.0, 1.0) * shake_intensity)
    else:
        offset = Vector2(0, 0)

func shake():
    shake_duration = 10