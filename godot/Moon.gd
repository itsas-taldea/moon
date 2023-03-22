extends VBoxContainer

var _texture_back = load("res://assets/Back.png")

const TILE_SIZE = Vector2(60,60)

enum State {Start, Argument, Operation}
var state : State = State.Start
var operation : String
var argument : String

const atomic = ["DEC", "INC", "ROL", "ROR", "NOT"]

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
	
	for id in ["A", "B", "C", "D"]:
		_Registries_setup($Display/Registries.get_node("R%s" % id), id)

	for id in ["DEC", "INC", "ROL", "ROR", "NOT"]:
		_Operations_setup($Operations/OH.get_node(id), id)

	for id in ["MOV", "OR", "AND", "XOR"]:
		_Operations_setup($Operations/OL.get_node(id), id)

	$Display/Registries/RA/Button.connect("pressed", self._on_RA_pressed)
	$Display/Registries/RB/Button.connect("pressed", self._on_RB_pressed)
	$Display/Registries/RC/Button.connect("pressed", self._on_RC_pressed)
	$Display/Registries/RD/Button.connect("pressed", self._on_RD_pressed)
	
	$Operations/OH/DEC.connect("pressed", self._on_DEC_pressed)
	$Operations/OH/INC.connect("pressed", self._on_INC_pressed)
	$Operations/OH/ROL.connect("pressed", self._on_ROL_pressed)
	$Operations/OH/ROR.connect("pressed", self._on_ROR_pressed)
	$Operations/OH/NOT.connect("pressed", self._on_NOT_pressed)
	$Operations/OL/MOV.connect("pressed", self._on_MOV_pressed)
	$Operations/OL/OR.connect("pressed", self._on_OR_pressed)
	$Operations/OL/AND.connect("pressed", self._on_AND_pressed)
	$Operations/OL/XOR.connect("pressed", self._on_XOR_pressed)
	
	for id in ["A", "B", "C", "D"]:
		var rid = "R%s" % id
		$Display/Registries.get_node(rid).set_Value(registries[id])
	
	#$Display/Registries/RC.disable()
	
	$Energy.set_Value(5)

func _TextureRect_setup(item):
	item.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	item.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(TILE_SIZE)

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

func _TextureButton_setup(item):
	item.set_ignore_texture_size(true)
	item.set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(TILE_SIZE)
	
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

func _process(delta):
	pass

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

#
# Registries
#

func _on_reg_pressed(id):
	var item = $Display/Registries.get_node("R%s" % id)
	if state == State.Operation:
		_compute_operation_on(id)
		item.set_Value(registries[id])
		state = State.Start
		return
	if state == State.Argument:
		argument = id
		state = State.Operation

func _on_RA_pressed():
	_on_reg_pressed("A")

func _on_RB_pressed():
	_on_reg_pressed("B")

func _on_RC_pressed():
	_on_reg_pressed("C")

func _on_RD_pressed():
	_on_reg_pressed("D")

#
# Operations
#

func _on_op_pressed(op):
	argument = ""
	operation = op
	if op in atomic:
		state = State.Operation
	else:
		state = State.Argument

func _on_DEC_pressed():
	_on_op_pressed("DEC")

func _on_INC_pressed():
	_on_op_pressed("INC")

func _on_ROL_pressed():
	_on_op_pressed("ROL")

func _on_ROR_pressed():
	_on_op_pressed("ROR")

func _on_NOT_pressed():
	_on_op_pressed("NOT")

func _on_MOV_pressed():
	_on_op_pressed("MOV")

func _on_OR_pressed():
	_on_op_pressed("OR")

func _on_AND_pressed():
	_on_op_pressed("AND")

func _on_XOR_pressed():
	_on_op_pressed("XOR")
