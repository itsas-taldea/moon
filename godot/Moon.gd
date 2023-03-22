extends VBoxContainer

var _texture_back = load("res://assets/Back.png")
var _textures_goals = []

const _tile_size = Vector2(60,60)

const _ops = {
	"H": ["DEC", "INC", "ROL", "ROR", "NOT"],
	"L": ["MOV", "OR", "AND", "XOR"]
}
const _atomic = ["DEC", "INC", "ROL", "ROR", "NOT"]

enum State {Start, Argument, Operation}
var state : State = State.Start
var operation : String
var argument : String

var registries = {
	"A": "1010",
	"B": "0101",
	"C": "0001",
	"D": "0011",
}

func _ready():
	_Energy_setup()
	_Key_setup()
	_Goals_setup()
	for idx in range(16):
		_textures_goals.append(load("res://assets/goals/%02d.png" % idx))
	
	for id in ["A", "B", "C", "D"]:
		var node = $Display/Registries.get_node("R%s" % id)
		_Registries_setup(node, id)
		node.get_node("Button").pressed.connect(self._on_reg_pressed.bind(id))

	for row in _ops:
		var rnode = $Operations.get_node("O%s" % row)
		for id in _ops[row]:
			var node = rnode.get_node(id)
			_Operations_setup(node, id)
			node.pressed.connect(self._on_op_pressed.bind(id))

	# Write some initial values to the registries, for testing.
	for id in ["A", "B", "C", "D"]:
		var rid = "R%s" % id
		$Display/Registries.get_node(rid).set_Value(registries[id])
	
	#$Display/Registries/RC.disable()
	
	$Energy.set_Value(5)

func _TextureRect_setup(item):
	item.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	item.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(_tile_size)

func _TextureButton_setup(item):
	item.set_ignore_texture_size(true)
	item.set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(_tile_size)

func _Energy_setup():
	for idx in range(6):
		_TextureRect_setup($Energy.get_node("E%s" % idx))

func _Key_setup():
	for idx in range(4):
		var item = $Key.get_node("K%s" % idx)
		item.set_texture(load("res://assets/B%s.png" % 2**idx))
		_TextureRect_setup(item)
		
func _Goals_setup():
	$Key/Goal.set_texture_normal(_texture_back)
	_TextureButton_setup($Key/Goal)
	$Key/Done.set_texture(_texture_back)
	_TextureRect_setup($Key/Done)
	for idx in range(4):
		var item = $Display/Goals.get_node("G%s" % idx)
		item.set_texture(_texture_back)
		_TextureRect_setup(item)

func _Registries_setup(item, id):
	for idx in range(4):
		_TextureRect_setup(item.get_node("B%d" % idx))
	var btn_item = item.get_node("Button")
	btn_item.set_texture_normal(load("res://assets/registries/%s.png" % id))
	btn_item.set_texture_disabled(load("res://assets/registries/%s-err.png" % id))
	_TextureButton_setup(btn_item)

func _Operations_setup(item, id):
	item.set_texture_normal(load("res://assets/operations/%s.png" % id))
	#item.set_texture_disabled(load("res://assets/operations/%s-err.png" % id))
	_TextureButton_setup(item)

#
# Process
#

#func _process(delta):
#	pass

func _int2bin(value):
	var out = ""
	while value > 0:
		out = str(value & 1) + out
		value = value >> 1
	while len(out) < 4:
		out = "0" + out
	# Truncate to four bits (handle Overflow)
	return out.right(4)

func _compute_operation_on(reg):
	var val = registries[reg]
	match operation:
		"DEC":
			var intval = val.bin_to_int()-1
			if intval<0:
				# Underflow
				intval = 15
			registries[reg] = _int2bin(intval)
		"INC":
			registries[reg] = _int2bin(val.bin_to_int()+1)
		"ROL":
			registries[reg] = val.right(3) + val[0]
		"ROR":
			registries[reg] = val[3] + val.left(3)
		"NOT":
			for idx in len(val):
				val[idx]=str(int(!bool(int(val[idx]))))
			registries[reg] = val
		"MOV":
			registries[reg] = registries[argument]
		_:
			var intval = val.bin_to_int()
			var intarg = registries[argument].bin_to_int()
			match operation:
				"OR":
					registries[reg] = _int2bin(intval | intarg)
				"AND":
					registries[reg] = _int2bin(intval & intarg)
				"XOR":
					registries[reg] = _int2bin(intval ^ intarg)
				_:
					assert(false, "Unknown operation!")

func _on_reg_pressed(id):
	match state:
		State.Operation:
			_compute_operation_on(id)
			$Display/Registries.get_node("R%s" % id).set_Value(registries[id])
			state = State.Start
		State.Argument:
			argument = id
			state = State.Operation

func _on_op_pressed(op):
	argument = ""
	operation = op
	state = State.Operation if op in _atomic else State.Argument
