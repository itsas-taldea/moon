extends HBoxContainer

class_name Register

var _texture_on : Texture2D = load("res://assets/registers/ON.png")
var _texture_off : Texture2D = load("res://assets/registers/OFF.png")

func _add_child(node, node_name):
	node.set_name(node_name)
	#node.set_owner(self)
	self.add_child(node)
		
func _ready():
	for idx in range(3,-1,-1):
		_add_child(TextureRect.new(), "B%s" % idx)
	_add_child(TextureButton.new(), "Button")

func _char_to_texture(bit : String):
	assert(len(bit) == 1, "Bit length must be 1!")
	if bool(int(bit)):
		return _texture_on
	else:
		return _texture_off

func set_Value(arr : String):
	$B3.set_texture(_char_to_texture(arr[0]))
	$B2.set_texture(_char_to_texture(arr[1]))
	$B1.set_texture(_char_to_texture(arr[2]))
	$B0.set_texture(_char_to_texture(arr[3]))

func enable():
	$Button.set_disabled(false)

func disable():
	$Button.set_disabled(true)
