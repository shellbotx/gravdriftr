extends AudioStreamPlayer

var g

func _ready():
    g = get_node("/root/global")
    
    
func _process(delta):
    # Fade in on start
    if jukebox.volume_db < 0:
        jukebox.volume_db += 0.25
        
    # Mute based on global setting
    if g.muted:
        self.stop()
    elif not self.playing:
        self.play()


func _on_Jukebox_finished():
    self.play()
