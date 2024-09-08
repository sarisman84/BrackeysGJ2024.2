@tool
extends Node

var item_registry : Array

func _get_property_list() -> Array[Dictionary]:
	var prop : Array[Dictionary] = []

	prop.append({
		"name":"item_registry",
		"type":TYPE_ARRAY,
		"usage":PROPERTY_USAGE_DEFAULT,
		"hint":PROPERTY_HINT_TYPE_STRING,
		"hint_string":str("%d/%d:" + "BaseWeapon" + "/%d:"+ "BasePowerup") % \
			[TYPE_OBJECT, PROPERTY_HINT_RESOURCE_TYPE, PROPERTY_HINT_RESOURCE_TYPE]
	})

	#prop.append({
		#"name": "Item Registry",
		#"type":TYPE_NIL,
		#"usage": PROPERTY_USAGE_GROUP
	#})
	#for i in item_count:
		#prop.append({
			#"name": "Entry_" + String.num_int64(i),
			#"type":TYPE_NIL,
			#"usage": PROPERTY_USAGE_SUBGROUP
		#})
		#prop.append({
			#"name" : "id",
			#"type" : TYPE_STRING,
			#"usage" : PROPERTY_USAGE_DEFAULT
		#})
		#prop.append({
			#"name" : "data",
			#"type" : TYPE_OBJECT,
			#"usage" : PROPERTY_USAGE_DEFAULT
		#})
	return prop
