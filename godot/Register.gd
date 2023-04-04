extends HBoxContainer

class_name Register

const _texture_on : Texture2D = preload("res://assets/registers/ON.png")
const _texture_off : Texture2D = preload("res://assets/registers/OFF.png")

var _wordlength : int

var Value:
	get = get_value, set = set_value
	
func get_value():
	return Value

func set_value(val):
	Value = val
	for idx in _wordlength:
		self.get_node("B%d" % idx).set_texture(_texture_on if bool(val & (1<<idx)) else _texture_off)

func _init(wordlength : int):
	_wordlength = wordlength
	for idx in range(wordlength-1,-1,-1):
		Utils.TextureRect_setup(
			Utils.Add_named_child(
				self,
				TextureRect.new(),
				"B%s" % idx
			)
		)
	Utils.Add_named_child(self, TextureButton.new(), "Button")
	Value = 0

func enable():
	$Button.set_disabled(false)

func disable():
	$Button.set_disabled(true)
