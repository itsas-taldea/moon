extends HBoxContainer

const _texture_back = preload("res://assets/Back.png")
const _texture_on_magenta = preload("res://assets/registers/ON-magenta.png")
const _texture_off_magenta = preload("res://assets/registers/OFF-magenta.png")

const wordlength : int = 6

func _ready():
	var node = null
	
	for idx in range(wordlength-1,-1,-1):
		node = Utils.Add_named_child($CPU/Key, TextureRect.new(), "K%d" % idx)
		node.set_texture(load("res://assets/B%s.png" % 2**idx))
		Utils.TextureRect_setup(node)

	node = Utils.Add_named_child($CPU/Key, TextureButton.new(), "Goal")
	node.set_texture_normal(_texture_off_magenta)
	Utils.TextureButton_setup(node)

	node = Utils.Add_named_child($CPU, ProgramCounter.new(wordlength), "PC").get_node("Button")
	node.set_texture_normal(load("res://assets/Eagle.png"))
	Utils.TextureButton_setup(node)

	for id in ["A", "B", "C", "D"]:
		node = Utils.Add_named_child($CPU, Register.new(wordlength), "R%s" % id).get_node("Button")
		node.set_texture_normal(load("res://assets/registers/%s.png" % id))
		Utils.TextureButton_setup(node)
