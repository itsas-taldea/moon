extends HBoxContainer

var _texture_empty : Texture2D = load("res://assets/Empty.png")
var _texture_full : Texture2D = load("res://assets/Full.png")

func _ready():
	for idx in 6:
		var node = TextureRect.new()
		node.set_name("E%s" % idx)
		self.add_child(node)

func _int_to_texture(val: int):
	if bool(val):
		return _texture_full
	else:
		return _texture_empty

func set_Value(val: int):
	assert(val >= 0, "Energy value cannot be negative!")
	assert(val <= 6, "Energy value cannot be larger than 6!")
	$E0.set_texture(_int_to_texture(val > 0))
	$E1.set_texture(_int_to_texture(val > 1))
	$E2.set_texture(_int_to_texture(val > 2))
	$E3.set_texture(_int_to_texture(val > 3))
	$E4.set_texture(_int_to_texture(val > 4))
	$E5.set_texture(_int_to_texture(val > 5))
