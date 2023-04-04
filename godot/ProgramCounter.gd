extends Register

class_name ProgramCounter

const _texture_on_high : Texture2D = preload("res://assets/registers/ON-yellow.png")
const _texture_off_high : Texture2D = preload("res://assets/registers/OFF-yellow.png")
const _texture_on_low : Texture2D = preload("res://assets/registers/ON-green.png")
const _texture_off_low : Texture2D = preload("res://assets/registers/OFF-green.png")

func set_value(val):
		Value = val
		for idx in _wordlength/2:
			self.get_node("B%d" % idx).set_texture(_texture_on_low if bool(val & (1<<idx)) else _texture_off_low)
			self.get_node("B%d" % (_wordlength/2+idx)).set_texture(_texture_on_high if bool(val & (1<<(_wordlength/2+idx))) else _texture_off_high)
