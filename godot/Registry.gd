extends HBoxContainer

var _texture_on : Texture2D = load("res://assets/registries/ON.png")
var _texture_off : Texture2D = load("res://assets/registries/OFF.png")

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
