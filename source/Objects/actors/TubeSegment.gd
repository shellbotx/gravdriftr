extends Area2D

# The force to apply to the player when in this segment
export (Vector2) var normal = Vector2(0, 0)

var player_ref = null

func on_area_enter(area):
    if area.name == 'Player':
        player_ref = area
        
func on_area_exit(area):
    if area.name == 'Player':
        player_ref = null
        

func _physics_process(delta):
    if player_ref != null:
        var env_force = player_ref.environment_force.x

        if normal.x == 0:
            if abs(env_force) > 0.5:
                player_ref.environment_force.x -= env_force / 20
            else:
                player_ref.environment_force.x = 0
        elif normal.x != 0:
            player_ref.environment_force.x += normal.x
