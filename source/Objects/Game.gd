extends Node2D  

var score = 0
var difficulty_timer = 0

var max_well_size = 1
var max_well_speed = 3

const L2_MIN = 10
const L3_MIN = 25
const L4_MIN = 50
var level_reached = 1


const Rock = preload("res://Objects/actors/obj_Rock.tscn")
const PurpleWell = preload("res://Objects/actors/obj_PurpleWell.tscn")
const RedWell = preload("res://Objects/actors/obj_RedWell.tscn")
const YellowWell = preload("res://Objects/actors/obj_YellowWell.tscn")


var global
var jukebox


func _ready():
    jukebox = get_node('/root/jukebox')
    jukebox.volume_db = 0.0
    
    randomize()
    $Timers/StartTimer.start()
    

func calculate_player_pipe_z():
    var player = $Player
    var base = $Pipe/Base
    
    if player == null:
        gameover()
    else:
        var dist = player.position.distance_to(base.position)
            
        var target_z
        
        if dist > 30:
            target_z = 1 - ((pow(dist - 30, 2) / 40000))
        else:
            target_z = 1
            
        player.ground_z = target_z
        if not player.aerial: 
            player.set_z(target_z)


func gameover():
    global = get_node("/root/global")
    
    if score > global.highscore:
        global.highscore = score


func generate_rock():
    var rock = Rock.instance()
    rock.position = $MobPath/MobSpawnLocation.position
    rock.velocity = Vector2(0, rand_range(1, 6))
    rock.rotation = rand_range(0, PI)
    rock.rotation_speed = rand_range(-4, 4)
    add_child(rock)
    

func generate_purple():
    var purple = PurpleWell.instance()
    purple.position = $MobPath/MobSpawnLocation.position
    var scale = rand_range(1, max_well_size)
    purple.scale = Vector2(scale, scale)    
    purple.velocity = Vector2(0, rand_range(1, max_well_speed))
    purple.rotation = rand_range(0, PI)
    purple.rotation_speed = rand_range(-1, 1)
    add_child(purple)
    

func generate_red():
    var red = RedWell.instance()
    red.player_ref = $Player
    red.position = $MobPath/MobSpawnLocation.position
    red.velocity = Vector2(0, 1)
    red.rotation = rand_range(0, PI)
    red.rotation_speed = rand_range(-2, 2)
    add_child(red)
    
    
func generate_yellow():
    var yellow = YellowWell.instance()
    yellow.position = $MobPath/MobSpawnLocation.position
    var scale = rand_range(1, max_well_size)
    yellow.scale = Vector2(scale, scale)
    yellow.velocity = Vector2(0, rand_range(1, max_well_speed))
    yellow.rotation = rand_range(0, PI)
    yellow.rotation_speed = rand_range(-1, 1)
    add_child(yellow)


func update_score(new_score):
    score = new_score
    $UI/ScoreLabel.text = '%04d' % score


func change_label(label, text):
    if label.text != text:
        label.text = text


func _physics_process(delta):
    if Input.is_action_just_pressed('ui_cancel'):
        get_tree().change_scene("res://Objects/Menu.tscn")
    
    calculate_player_pipe_z()
    

func _on_DifficultyTimer_timeout():
    # increase difficulty
    difficulty_timer += 1
    
    # initial change
    if level_reached == 1 and difficulty_timer == L2_MIN:
        level_reached = 2
        $UI/LevelLabel.text = 'LEVEL 2'
        $Background.speed_y = 1
    elif level_reached == 2 and difficulty_timer == L3_MIN:
        level_reached = 3
        $UI/LevelLabel.text = 'LEVEL 3'
        $Background.speed_y = 2.5
        $Timers/MobTimer.wait_time = 1.5
    elif level_reached == 3 and difficulty_timer == L4_MIN:
        level_reached = 4
        $UI/LevelLabel.text = 'LEVEL 4'
        $Timers/MobTimer.wait_time = 0.5
    
    
    # ongoing increase
    if level_reached == 4:
        pass
    elif level_reached == 3:    
        $Background.speed_y += 0.25
        max_well_speed += 0.1
    elif level_reached == 2:       
        $Background.speed_y += 0.1
        $Timers/MobTimer.wait_time -= 0.025
        max_well_size += 0.04  # 0.025
        max_well_speed += 0.075
    else:
        $Background.speed_y += 0.1
    

func _on_MobTimer_timeout():
    $MobPath/MobSpawnLocation.set_offset(randi())
    
    var gen = rand_range(0, 100)
    
    if gen <= 10 and level_reached >= 4:
        generate_red()
    elif gen <= 30 and level_reached >= 3:
        generate_yellow()
    elif gen <= 50 and level_reached >= 2:
        generate_purple()
    else:
        generate_rock()
    

func _on_ScoreTimer_timeout():
    update_score(score + 1)


func _on_StartTimer_timeout():
    $UI/LevelLabel.show()
    $UI/ScoreLabel.show()
    $Timers/DifficultyTimer.start()
    $Timers/MobTimer.start()
    $Timers/ScoreTimer.start()
 

func _on_Blackhole_area_entered( area ):
    # Rock = 10
    # Purple = 25
    # Yellow = 25
    # Red = 50
    
    if area.is_in_group('destructable'):
        if area.is_in_group('red'):
            score += 50
        elif area.is_in_group('well'):
            score += 25
        elif area.is_in_group('rock'):
            score += 10
        
        if area.name == 'Player':
            $Player.emit_signal("dead")
        else:
            area.queue_free()


func _on_Player_dead():
    $Timers/ScoreTimer.stop()
    jukebox.volume_db = -30
    $Sounds/sfxGameOver.play()
    $Player.queue_free()

    
func _on_Player_trick():
    update_score(score + 10)
    

func return_to_mainmenu():
    get_tree().change_scene("res://Objects/Menu.tscn")
