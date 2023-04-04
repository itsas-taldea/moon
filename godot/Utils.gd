extends Node

class_name Utils

const _tile_size = Vector2(50,50)

static func TextureRect_setup(node):
	node.set_expand_mode(TextureRect.EXPAND_IGNORE_SIZE)
	node.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	node.set_custom_minimum_size(_tile_size)

static func TextureButton_setup(node):
	node.set_ignore_texture_size(true)
	node.set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	node.set_custom_minimum_size(_tile_size)

static func Add_named_child(parent, node, node_name):
	node.set_name(node_name)
	parent.add_child(node)
	return node
