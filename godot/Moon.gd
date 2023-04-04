extends VBoxContainer

var _texture_back = load("res://assets/Back.png")
var _textures_goals = []

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

var registers = {
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
	_Registers_setup()
	_Operations_setup()

	# Write some initial values to the Registers, for testing.
	for id in ["A", "B", "C", "D"]:
		var rid = "R%s" % id
		$Display/Registers.get_node(rid).set_Value(registers[id])

	#$Display/Registers/RC.disable()

	$Energy.set_Value(5)

	_shuffle()
	_next_goal()

func _Energy_setup():
	for idx in 6:
		Utils.TextureRect_setup($Energy.get_node("E%s" % idx))

func _Key_and_Goals_setup():
	for idx in range(3,-1,-1):
		var node = Utils.Add_named_child($Display/Registers/Key, TextureRect.new(), "K%s" % idx)
		node.set_texture(load("res://assets/B%s.png" % 2**idx))
		Utils.TextureRect_setup(node)

	var node = Utils.Add_named_child($Display/Registers/Key, TextureButton.new(), "Goal")
	node.pressed.connect(self._on_goal_pressed)
	node.set_texture_normal(_texture_back)
	Utils.TextureButton_setup(node)
	for idx in 5:
		Utils.TextureRect_setup(Utils.Add_named_child($Display/Goals, TextureRect.new(), "G%s" % idx))

func _Registers_setup():
	for id in ["A", "B", "C", "D"]:
		var node = Utils.Add_named_child($Display/Registers, Register.new(), "R%s" % id)
		_Register_setup(node, id)
		node.get_node("Button").pressed.connect(self._on_reg_pressed.bind(id))

func _Register_setup(node, id):
	for idx in 4:
		Utils.TextureRect_setup(node.get_node("B%d" % idx))
	var btn_node = node.get_node("Button")
	btn_node.set_texture_normal(load("res://assets/registers/%s.png" % id))
	btn_node.set_texture_disabled(load("res://assets/registers/%s-err.png" % id))
	Utils.TextureButton_setup(btn_node)

func _Operations_setup():
	for row in _ops:
		var rnode = $Operations.get_node("O%s" % row)
		for id in _ops[row]:
			var node = Utils.Add_named_child(rnode, TextureButton.new(), id)
			_Operation_setup(node, id)
			node.pressed.connect(self._on_op_pressed.bind(id))

func _Operation_setup(item, id):
	item.set_texture_normal(load("res://assets/operations/%s.png" % id))
	#item.set_texture_disabled(load("res://assets/operations/%s-err.png" % id))
	Utils.TextureButton_setup(item)

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
	var val = registers[reg]
	match operation:
		"DEC":
			var intval = val.bin_to_int()-1
			if intval<0:
				# Underflow
				intval = 15
			registers[reg] = _int2bin(intval)
		"INC":
			registers[reg] = _int2bin(val.bin_to_int()+1)
		"ROL":
			registers[reg] = val.right(3) + val[0]
		"ROR":
			registers[reg] = val[3] + val.left(3)
		"NOT":
			for idx in len(val):
				val[idx]=str(int(!bool(int(val[idx]))))
			registers[reg] = val
		"MOV":
			registers[reg] = registers[argument]
		_:
			var intval = val.bin_to_int()
			var intarg = registers[argument].bin_to_int()
			match operation:
				"OR":
					registers[reg] = _int2bin(intval | intarg)
				"AND":
					registers[reg] = _int2bin(intval & intarg)
				"XOR":
					registers[reg] = _int2bin(intval ^ intarg)
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
	$Display/Goals.get_node("G0").set_texture(_textures_goals[slots.front()])
	for idx in range(1, len_slots, 1):
		$Display/Goals.get_node("G%s" % idx).set_texture(_texture_back)
	for idx in 5-len_slots:
		$Display/Goals.get_node("G%s" % (len_slots+idx)).set_texture(null)

func _check_goal():
	if registers["A"].bin_to_int() == slots.front():
		slots.pop_front()
		$ProgressBar.value = 1-(float(len(goals))/16)
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
			$Display/Registers.get_node("R%s" % id).set_Value(registers[id])
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
