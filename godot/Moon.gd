extends VBoxContainer

var _texture_back = load("res://assets/Back.png")
var _textures_goals = []

const _tile_size = Vector2(60,60)

const _ops = {
	"H": ["DEC", "INC", "ROL", "ROR", "NOT"],
	"L": ["MOV", "OR", "AND", "XOR"]
}

const _ops_energy = {
	"DEC": 4,
	"INC": 4,
	"ROL": 2,
	"ROR": 2,
	"NOT": 2,
	"MOV": 2,
	"OR": 1,
	"AND": 1,
	"XOR": 1,
}

const _atomic = ["DEC", "INC", "ROL", "ROR", "NOT"]

enum State {Start, Argument, Operation, Done}
var state : State = State.Start
var operation : String
var argument : String

var goals = []
var slots = []

var registries = {
	"A": "1010",
	"B": "0101",
	"C": "0001",
	"D": "0011",
}

func _ready():
	for idx in 16:
		_textures_goals.append(load("res://assets/goals/%02d.png" % idx))
	_Energy_setup()
	_Key_and_Goals_setup()
	_Registries_setup()
	_Operations_setup()

	# Write some initial values to the registries, for testing.
	for id in ["A", "B", "C", "D"]:
		var rid = "R%s" % id
		$Display/Registries.get_node(rid).set_Value(registries[id])
	
	#$Display/Registries/RC.disable()

	$Energy.set_Value(5)

	_shuffle()
	_next_goal()

func _TextureRect_setup(item):
	item.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	item.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(_tile_size)

func _TextureButton_setup(item):
	item.set_ignore_texture_size(true)
	item.set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	item.set_custom_minimum_size(_tile_size)

func _add_child(parent, node, node_name):
	node.set_name(node_name)
	parent.add_child(node)
	return node

func _Energy_setup():
	for idx in 6:
		_TextureRect_setup($Energy.get_node("E%s" % idx))

func _Key_and_Goals_setup():
	for idx in range(3,-1,-1):
		var node = _add_child($Display/Registries/Key, TextureRect.new(), "K%s" % idx)
		node.set_texture(load("res://assets/B%s.png" % 2**idx))
		_TextureRect_setup(node)

	var node = _add_child($Display/Registries/Key, TextureButton.new(), "Goal")
	node.pressed.connect(self._on_goal_pressed)
	node.set_texture_normal(_texture_back)
	_TextureButton_setup(node)
	for idx in 5:
		_TextureRect_setup(_add_child($Display/Goals, TextureRect.new(), "G%s" % idx))

func _Registries_setup():
	for id in ["A", "B", "C", "D"]:
		var node = _add_child($Display/Registries, Registry.new(), "R%s" % id)
		_Registry_setup(node, id)
		node.get_node("Button").pressed.connect(self._on_reg_pressed.bind(id))

func _Registry_setup(node, id):
	for idx in 4:
		_TextureRect_setup(node.get_node("B%d" % idx))
	var btn_node = node.get_node("Button")
	btn_node.set_texture_normal(load("res://assets/registries/%s.png" % id))
	btn_node.set_texture_disabled(load("res://assets/registries/%s-err.png" % id))
	_TextureButton_setup(btn_node)

func _Operations_setup():
	for row in _ops:
		var rnode = $Operations.get_node("O%s" % row)
		for id in _ops[row]:
			var node = _add_child(rnode, TextureButton.new(), id)
			_Operation_setup(node, id)
			node.pressed.connect(self._on_op_pressed.bind(id))

func _Operation_setup(item, id):
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

func _shuffle():
	goals = range(16)
	goals.shuffle()
	slots = []

func _next_goal():
	if goals.is_empty():
		print("Landing was successful! Congratulations!")
		state = State.Done
		return
	slots.push_back(goals.pop_front())
	_update_slots()

func _update_slots():
	var len_slots = len(slots)
	for idx in len_slots:
		$Display/Goals.get_node("G%s" % idx).set_texture(_textures_goals[slots[idx]])
	for idx in 5-len_slots:
		$Display/Goals.get_node("G%s" % (len_slots+idx)).set_texture(_texture_back)

func _check_goal():
	if registries["A"].bin_to_int() == slots.front():
		slots.pop_front()
		if slots.is_empty():
			_next_goal()
			return
		_update_slots()

func _on_goal_pressed():
	if len(slots) >= 5:
		# FIXME
		# This should be handled by changing the texture of the Goal button to let the user know that
		# all the slots are being used.
		# If the user clicks on the button, the game should be finished as failing to achieve the objective.
		# For now, we shuffle and start again.
		_shuffle()
	_next_goal()

func _on_reg_pressed(id):
	match state:
		State.Operation:
			_compute_operation_on(id)
			$Display/Registries.get_node("R%s" % id).set_Value(registries[id])
			if id == "A":
				_check_goal()
				if state == State.Done:
					return
			state = State.Start
		State.Argument:
			argument = id
			state = State.Operation

func _on_op_pressed(op):
	argument = ""
	operation = op
	state = State.Operation if op in _atomic else State.Argument
