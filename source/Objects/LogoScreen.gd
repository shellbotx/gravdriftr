extends Node2D

var done = false

func _on_Fade_complete():
    if not done:
        
        # wait for a sec
        var t = Timer.new()
        t.set_wait_time(1)
        t.set_one_shot(true)
        self.add_child(t)
        t.start()
        yield(t, "timeout")
        t.queue_free()

        $Fade.reverse()
        done = true
    else:
        get_tree().change_scene("res://Objects/Menu.tscn")
