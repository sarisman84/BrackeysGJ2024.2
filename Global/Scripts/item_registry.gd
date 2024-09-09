extends Node

@export var item_registry : Array[BaseResource]

func get_item(item_name : String) -> Variant:
	for i in item_registry:
		print(i.resource_name)
		if i.resource_path.contains(item_name):
			return i.duplicate()
	return null
