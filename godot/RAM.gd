extends GridContainer

const _font_zygo = preload("res://assets/Zygo.ttf")
const _texture_ram = preload("res://assets/RAM.png")

func _int2bin(value):
	var out = ""
	for idx in 3:
	#while value > 0:
		out = str(value & 1) + out
		value = value >> 1
	return out

func _add_label(node_name, text):
	var node = Utils.Add_named_child(self, Label.new(), node_name)
	node.text = text
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	node.add_theme_font_override("font", _font_zygo)
	node.add_theme_font_size_override("font_size", 12)
	
func _ready():
	var node = null
	node = Utils.Add_named_child(self, TextureRect.new(), "RAM")
	node.set_texture(_texture_ram)
	Utils.TextureRect_setup(node)
	for idx in 8:
		_add_label("C%d" % idx, _int2bin(idx))
	for idy in 8:
		_add_label("R%d" % idy, _int2bin(idy))
		for idx in 8:
			node = Utils.Add_named_child(self, TextureRect.new(), "M%d" % (idy*8+idx))
			node.set_texture(load("res://assets/ram/M0.png"))
			Utils.TextureRect_setup(node)
