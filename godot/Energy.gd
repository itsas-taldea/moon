extends HBoxContainer

const _textures = [
	preload("res://assets/Empty.png"),
	preload("res://assets/Half.png"),
	preload("res://assets/Full.png"),
]

var Capacity : int :
	get:
		return Capacity
	set(val):
		if Capacity == val:
			return
		var last_node = (Capacity/2)-1
		if Capacity > val:
			for idx in (Capacity-val)/2:
				self.get_node("E%d" % (last_node - idx)).queue_free()
		elif Capacity < val:
			for idx in (val-Capacity)/2:
				Utils.TextureRect_setup(
					Utils.Add_named_child(
						self,
						TextureRect.new(),
						"E%d" % (last_node + idx + 1 )
					)
				)
		Capacity = val
		Energy = min(Energy, val)

var Energy : int:
	get:
		return Energy
	set(val):
		assert(val >= 0, "Energy value cannot be negative!")
		assert(val <= Capacity, "Energy value cannot be larger than %d!" % Capacity)
		Energy = val
		# FIXME The following is hardcoded for Capacity=6.
		# Need to adjust it for any value of Capacity.
		$E0.set_texture(_textures[2 if val > 1 else val])
		$E1.set_texture(_textures[2 if val > 3 else 0 if val < 2 else val-2])
		$E2.set_texture(_textures[0 if val < 4 else val-4])

func _ready():
	Capacity = 6
