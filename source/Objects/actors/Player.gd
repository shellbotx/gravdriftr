extends Area2D

signal did_trick
signal dead
signal hit

const ACCEL_SPEED = 0.25
const MAX_SPEED = 5
const ROTATION_SPEED = 0.05

const TRICK_DURATION = 9

const JUMP_FORCE = 0.15
const JUMP_DEG = JUMP_FORCE / 10


# The force the user applies through input
var user_force = Vector2()

# The force the game applies through mechanics
var environment_force = Vector2()

var aerial = false
var tricking = false

var trick_timer = 0

var z_velocity = 0
var z_pos = 1
var ground_z = 1  # set by Game.gd

func _ready():
    z_index = 100
    

func _process(delta):
    var keydown_left = Input.is_action_pressed('ui_left')
    var keydown_right = Input.is_action_pressed('ui_right')
    var keypress_action = Input.is_action_just_pressed('jump')
    
    if $sfxEngine.volume_db > -20:
        $sfxEngine.volume_db -= 0.15
    
    # process movement input
    if not aerial:
        if keydown_left != keydown_right:
            if keydown_left:
                user_force.x -= ACCEL_SPEED
    
            elif keydown_right:
                user_force.x += ACCEL_SPEED
                
            user_force.x = clamp(user_force.x, -MAX_SPEED, MAX_SPEED)
        else:
            if user_force.x > ACCEL_SPEED:
                user_force.x -= ACCEL_SPEED
            elif user_force.x < -ACCEL_SPEED:
                user_force.x += ACCEL_SPEED
            else:
                user_force.x = 0

    # process action input
    if keypress_action:
        if not aerial:
            jump()
            z_velocity = JUMP_FORCE
        else:
            trick()
            
    if aerial:
        set_z(z_pos + z_velocity)
        z_velocity -= JUMP_DEG
        
        if tricking:
            $Sprite/SprSprite.rotation = deg2rad(45) * (TRICK_DURATION - trick_timer)
            trick_timer -= 1
            
            if trick_timer <= 0:
                trick_timer = 0
                tricking = false
                emit_signal("did_trick")
        
        if z_pos <= ground_z:
            ground()
            z_pos = 1
            set_z(z_pos)
            

    # calc velocity (input + environment)
    var vel_x
    
    if aerial:
        vel_x = user_force.x
    else:
        vel_x = user_force.x + environment_force.x
    
    # calc rotation (velocity)
    if not tricking:
        var rotate = clamp(vel_x, -MAX_SPEED, MAX_SPEED)
        rotate = 0.6 * (vel_x / MAX_SPEED)
        self.rotation = rotate
             
    # move position
    position.x += user_force.x + environment_force.x
    position.y += user_force.y + environment_force.y
    
    # stabilize env_force
    if environment_force.y > 0:
        environment_force.y -= 0.0125
    if abs(environment_force.y) < 0.05:
        environment_force.y = 0
    
    # Juice trail
    var trail_speed = 1
    if abs(user_force.x) + abs(user_force.y) > 1:
        trail_speed = 2
        if $sfxEngine.volume_db < -15:
            $sfxEngine.volume_db = -15

        
    # move back to baseline
    if position.y > 21 and environment_force.y == 0:
        position.y -= 0.25
        position.x += 0.5 * rand_range(-1, 1)
        trail_speed = 2.5
        
        if $sfxEngine.volume_db < -15:
            $sfxEngine.volume_db = -15
        
    elif position.y < 20 and environment_force.y == 0:
        position.y += 0.25
        trail_speed = 0.5
        
    else:
        position.x += 0.1 * rand_range(-1, 1)    
    
    $Trail.speed_scale = trail_speed
    
    
    
func rotate_to(target):
    if abs(rotation - target) > ROTATION_SPEED:
        if rotation < target:
            rotate(ROTATION_SPEED)
        elif rotation > target:
            rotate(-ROTATION_SPEED)


func set_z(z):
    z_pos = z
    get_node("Sprite").scale = Vector2(z, z)

    
func jump():
    aerial = true
    $Trail.emitting = false
    $sfxEngine.stop()
    $sfxJump.play()


func ground():
    aerial = false
    z_velocity = 0
    $Trail.emitting = true
    $sfxEngine.play()
    

func trick():
    tricking = true
    trick_timer = TRICK_DURATION
    $sfxJump.play()

func _on_Player_area_entered( area ):
    if area.is_in_group('well'):
        if not aerial:
            hide()
            emit_signal('dead')
            $CollisionShape2D.disabled = true
        else:
            # increase points for stunt, double for tricking
            pass
    elif area.is_in_group('rock'):
        if not aerial:
            emit_signal("hit")
    elif area.name == 'Blackhole':
        hide()
        emit_signal('dead')
        $CollisionShape2D.disabled = true


func _on_sfxEngine_finished():
    $sfxEngine.play()


func _on_Player_hit():
    if rand_range(0, 10) < 3:
        $sfxComeOn.play()
