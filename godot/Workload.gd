extends HBoxContainer

var limit : int = 5
var bugs : int = 0
var slots : Array[int] = []

func _ready():
	for idx in 5:
		var node = Utils.Add_named_child(self, ColorRect.new(), "W%d" % idx)
		node.set_h_size_flags(ColorRect.SIZE_EXPAND_FILL) 

func reset() -> void:
	bugs = 0
	slots = []

func bug() -> void:
	bugs += 1

func push(val: int) -> void:
	slots.push_back(val)

func pop() -> void:
	slots.pop_front()

func next() -> int:
	return slots.front()

func match(val: int) -> bool:
	var is_match : bool = val == self.next()
	if is_match:
		self.pop()
	return is_match

func monitor() -> int:
	return len(slots)

func critical() -> bool:
	return self.monitor() > (limit-bugs-1)

func update() -> void:
	var len_slots : int = len(slots)
	if len_slots != 0:
		for idx in len_slots-1:
			self.get_node("W%d" % idx).color = Color(0,0,1,0.5)
		self.get_node("W%d" % (len_slots-1)).color = Color(1,1,1,1)
	for idx in 5-len_slots:
		self.get_node("W%d" % (len_slots+idx)).color = Color(1,1,1,0.1)
