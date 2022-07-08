tool
class_name AnimationData extends Resource

export var character_name = ""
export var states := []
export(Array, Texture) var spritesheets = []
export var character_animations := ["RESET"]
export var char_file_name = ""
export var states_textures_map := {}
export var tracks := {}
var animTree :AnimationTree
#export var test_1 = ""
#export var this_is_a_test = "This is a test"

#func set_animTree(value) -> void:
#	get_local_scene().animTree = value
	
func set_property_value(property :String, value) -> void:
	match property:
		"character_name":
#			print("Property found: ", property)
			character_name = value
		"states":
#			print("Property found: ", property)
			states = value
		"spritesheets":
#			print("Property found: ", property)
			spritesheets = value
		"character_animations":
#			print("Property found: ", property)
			character_animations = value
		"char_file_name":
#			print("Property found: ", property)
			char_file_name = value
		"states_textures_map":
#			print("Property found: ", property)
			states_textures_map = value
		"tracks":
#			print("Property found: ", property)
			tracks = value
#		"test_1":
#			
#			test_1 = value
#		"this_is_a_test":
#			print("Property found: ", property)
#			this_is_a_test = value
		_:
			print("Property '%s' Not Found on Animation Data!" % property)
			print("You may need to update your AnimationDataResource on ", character_name)

func get_property_value(property :String):
	match property:
		"character_name":
#			print("Property found: ", property)
			return character_name
		"states":
#			print("Property found: ", property)
			return states
		"spritesheets":
#			print("Property found: ", property)
			return spritesheets
		"character_animations":
#			print("Property found: ", property)
			return character_animations
		"char_file_name":
#			print("Property found: ", property)
			return char_file_name
		"states_textures_map":
#			print("Property found: ", property)
			return states_textures_map
		"tracks":
#			print("Property found: ", property)
			return tracks
#		"test_1":
#			print("Property found: ", property)
#			return test_1
#		"this_is_a_test":
#			print("Property found: ", property)
#			return this_is_a_test
		_:
			print("Property '%s' Not Found on Animation Data!" % property)
			print("You may need to update your AnimationDataResource on ", character_name)
