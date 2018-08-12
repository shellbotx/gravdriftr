extends Area2D

export (Vector2) var facing = Vector2(0, 0)

func on_area_entered(area):
    if area.name == 'Player':
        if facing.x != 0:
            area.user_force.x = 0
            # TODO fix this
            if facing.x > 0:
                # right
                area.environment_force.x = 4
            else:
                area.environment_force.x = -4
        else:
            print("NO NORMAL@L!L!")