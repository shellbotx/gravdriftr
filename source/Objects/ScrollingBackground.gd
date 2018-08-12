extends Node2D

# Private properties

var _texture = null setget _private, _private
var _screen_size setget _private, _private

func _private(value = null):
	print("Invalid access to private variable!")
	return value

# Public properties

export (Texture) var texture setget set_texture, get_texture
export (float) var speed_x = 0
export (float) var speed_y = 1

# Setters/Getters

func set_texture(texture): 
	_texture = texture
	if not has_node("Background"):
		_refresh_child()
	else:
		_update_texture()

func get_texture(): return _texture

# Initialise node, once we're ready

func _ready():
    _refresh_child()

# Update the Background node based on settings

func _refresh_child():
	
	if _texture == null:
		# Texture not set, return early
		return
	
	if get_viewport() == null:
		# We don't yet have a viewport.
		return
	
	if not has_node("Background"):
		var spriteNode = Sprite.new()
		spriteNode.set_name("Background")
		add_child(spriteNode)
		
	_screen_size = get_viewport().get_visible_rect().size
	
	_update_texture()
	
	var spriteNode = get_node("Background")
	
	var current_position = spriteNode.position
	current_position.x = 0 - _texture.get_width() * scale.x
	current_position.y = 0 - _texture.get_height() * scale.y
	spriteNode.position = current_position

func _update_texture():
	var spriteNode = get_node("Background")
	
	spriteNode.texture = _texture
	_texture.set_flags(_texture.get_flags() | Texture.FLAG_REPEAT)

	var region_rect = Rect2(
		0,
		0,
		ceil(_screen_size.x / scale.x) + _texture.get_width() * 2,
		ceil(_screen_size.y / scale.y) + _texture.get_height() * 2
	)

	spriteNode.region_enabled = true
	spriteNode.region_rect = region_rect
	
	spriteNode.centered = false
	spriteNode.scale = scale
	
# Update the position according to speed and reset
# accordingly, so it looks like as if the background is 
# continously scrolling

func _physics_process(delta):
	
	if _texture == null:
		# Texture not set. Returning early
		return
	
	var spriteNode = get_node("Background")
	
	var current_position = spriteNode.position
	
	current_position.x = current_position.x + speed_x
	current_position.y = current_position.y + speed_y
	
	if (
		current_position.x < 0 - _texture.get_width() * scale.x * 2 ||
		current_position.x > 0
	):
		current_position.x = 0 - _texture.get_width() * scale.x
	
	if (
		current_position.y < 0 - _texture.get_height() * scale.y * 2||
		current_position.y > 0
	):
		current_position.y = 0 - _texture.get_height() * scale.y
	
	spriteNode.position = current_position

