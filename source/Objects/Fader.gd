extends TextureRect

signal complete

export (Color) var start = Color(0, 0, 0)
export (Color) var goal = Color(0, 0, 0)
export (bool) var autoplay = false
export (float) var duration = 1

var target = Color()
var active = false
var current = 0.0

var delta_r = 0.0
var delta_g = 0.0
var delta_b = 0.0
var delta_a = 0.0

func _ready():
    self.modulate.r = start.r
    self.modulate.g = start.g
    self.modulate.b = start.b
    self.modulate.a = start.a
    
    if autoplay:
        play()
        
        
func play():
    run(start, goal)
    
    
func reverse():
    run(goal, start)
        

func run(front, back):
    current = 0
    active = true
    target = back
    delta_r = (back.r - front.r) / duration
    delta_g = (back.g - front.g) / duration
    delta_b = (back.b - front.b) / duration
    delta_a = (back.a - front.a) / duration
    

func _process(delta):  
    if active:
        self.modulate.r += delta_r * delta
        self.modulate.g += delta_g * delta
        self.modulate.b += delta_b * delta
        self.modulate.a += delta_a * delta
        
        current += delta
        
        if current >= duration:
            self.modulate.r = target.r
            self.modulate.g = target.g
            self.modulate.b = target.b
            self.modulate.a = target.a
        
        if self.modulate == self.target:
            current = 0
            active = false
            emit_signal("complete")
    