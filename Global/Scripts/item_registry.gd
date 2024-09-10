extends Node

@export var item_registry : Array[BaseResource]

func _ready() -> void:
	for i in range(item_registry.size()):
		var item = item_registry[i]
		item.UUID = i
		item.init()

func get_item(item_name_or_uuid : Variant) -> Variant:
	for i in item_registry:
		match(typeof(item_name_or_uuid)):
			TYPE_STRING:
				if i.resource_path.to_lower().contains(item_name_or_uuid.to_lower()):
					return i.duplicate()
			TYPE_INT:
				if i.UUID == item_name_or_uuid:
					return i.duplicate()
	return null
