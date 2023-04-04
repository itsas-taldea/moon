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

var registers = {}

var wordlength : int = 4

func _ready():
	for idx in 16:
		_textures_goals.append(load("res://assets/goals/%02d.png" % idx))
	_Key_and_Goals_setup()
	_Registers_setup()
	_Operations_setup()

	# Write some initial values to the Registers, for testing.
	# The actual implementation depends on the difficulty.
	# Some registers are initialised to zero or one, and others to the value of the first goals.
	registers["A"].Value = 10
	registers["B"].Value = 5
	registers["C"].Value = 1
	registers["D"].Value = 3

	$Energy.Energy = 5

	_shuffle()
	_next_goal()

func _Key_and_Goals_setup():
	for idx in range(wordlength-1,-1,-1):
		var node = Utils.Add_named_child($Display/Registers/Key, TextureRect.new(), "K%d" % idx)
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
		var node = Utils.Add_named_child($Display/Registers, Register.new(wordlength), "R%s" % id)
		registers[id] = node
		var btn_node = node.get_node("Button")
		btn_node.pressed.connect(self._on_reg_pressed.bind(id))
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

func _compute_operation_on(reg):
	var rnode = registers[reg]
	var val = registers[reg].Value
	var max_mask = 2**wordlength-1
	match operation:
		"DEC": # Underflow
			rnode.Value = max_mask if val==0 else val-1
		"INC": # Overflow
			rnode.Value = 0 if val==max_mask else val+1
		"ROL":
			rnode.Value = (val*2 & max_mask) | int(bool(val & (1<<(wordlength-1))))
		"ROR":
			rnode.Value = val/2 | int(bool(val & 1))<<(wordlength-1)
		"NOT":
			rnode.Value = ~val & max_mask
		"MOV":
			rnode.Value = registers[argument].Value
		_:
			var arg = registers[argument].Value
			match operation:
				"OR":
					rnode.Value = val | arg
				"AND":
					rnode.Value = val & arg
				"XOR":
					rnode.Value = val ^ arg
				_:
					assert(false, "Unknown operation!")

func _shuffle():
	goals = range(2**wordlength)
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
	if registers["A"].Value == slots.front():
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
