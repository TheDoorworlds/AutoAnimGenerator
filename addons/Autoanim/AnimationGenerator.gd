tool
class_name AnimationGenerator extends Node

## ENUMS
enum Directions {SOUTH, SOUTHEAST, EAST, NORTHEAST, NORTH, NORTHWEST, WEST, SOUTHWEST }


# Errors regarding the creation of new characters
enum CHARACTER_CREATION_ERRORS { 
	PROBLEM_ADDING_CHARACTER = 0, # GENERIC catch-all error.  Mod author will attempt to track down specific causes and define out all errors.
	PROBLEM_SAVING_CHARACTER = 1, # Character or Charater Animation Data did not save to the directory properly.
	PROBLEM_SAVING_VARSTRACKER = 2, # AutoAnimVarsTracker did not save properly
	INVALID_DIRECTORY = 3, # The CharacterDirectory is invalid.  Assign a valid
	CHARACTER_ALREADY_EXISTS = 4,  # Character already exists in the VarsTracker CharacterList.  If the character doe snot exist in the Character Directory, inspect the Resources/AutoAnimVarsTracker.tres:CharacterList for issues.
	PROBLEM_PACKING_CHARCTER = 5, # There was a problem packng the character.
	INVALID_NAME = 6 # Emitted when the name provided is empty or will create an invalid filename
		}

## SIGNALS
signal finished_adding_children_to_new_character
signal character_succesfully_added(character_name)
signal character_not_added(reason, originating_script)
#signal direction_set_chosen(set_number)

## INTERNAL VARS
var varsTrackerPath := "res://addons/Autoanim/Resources/AutoAnimVarsTracker.tres"
var varsTracker :VarsTracker = load(varsTrackerPath)
var animationDataResource :Resource = load("res://addons/Autoanim/Resources/AnimationData.gd")

## SCENE REFERENCES
var auto_anim_tree := preload("res://addons/Autoanim/Scenes/AutoAnimationTree.tscn")
var base_character = preload("res://addons/Autoanim/CharacterBase/BaseCharacter.tscn")

## RESOURCE REFERENCES
var auto_anim_tree_root := preload("res://addons/Autoanim/Resources/AutoAnimationNodeBlendTree.tres")


## DEFAULTS - OBTAINED FROM TOOL MENU
var sprite_height :int = 0 setget set_sprite_height
var sprite_width :int = 0 setget set_sprite_width
var direction_set :int = 0 setget set_direction_set

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup_new_character(name :String) -> bool:
	## Check if the Character List already contains this character
	if varsTracker.CharacterList.has(name) or name == "" or !name.replace(" ", "").is_valid_filename():
		if name == "":
			print("No name provided, please provide a valid name.")
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.INVALID_NAME, self)
		elif !name.replace(" ", "").is_valid_filename():
			print("Name has invalid characters.  Please only use alpha-numeric and hyphens.")
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.INVALID_NAME, self)
		else:
			print("   Character %s Already Exists" % name)
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.CHARACTER_ALREADY_EXISTS, self)
		return false
	else:
		
		
	# Create necessary children for the character to be set up
		var new_character := OverworldCharacter.new()
		var nc_anim_player := AnimationPlayer.new()
		var nc_anim_tree := auto_anim_tree.instance()
		var nc_sprite := Sprite.new()
		var nc_coll_shape := CollisionShape2D.new()
		var nc_coll_shape_shape := CapsuleShape2D.new()
		var child_adds := [nc_anim_player, nc_anim_tree, nc_coll_shape, nc_sprite]
		var char_filepath := varsTracker.CharacterDirectory.plus_file(name.replace(" ", ""))
		# Add all children
		for child in child_adds:
			new_character.add_child(child)
			child.owner = new_character
#			emit_signal("finished_adding_children_to_new_character")
		# Sets character variables on the character
		new_character.name = name.replace(" ", "")
		new_character.character_name = name
		new_character.animPlayer = nc_anim_player
		new_character.animTree = nc_anim_tree
		new_character.sprite = nc_sprite
		new_character.collisionShape2D = nc_coll_shape
		new_character.collisionShapeShape = nc_coll_shape_shape
		
		# Give the CollisionShape2D its shape
		new_character.collisionShape2D.shape = new_character.collisionShapeShape
		# Set the CollisionShape2D's shape to be local to the scene
		new_character.collisionShapeShape.resource_local_to_scene = true
		
		# Setup the AnimationData resource
		var animation_data := AnimationData.new()
		new_character.animation_data = animation_data
		new_character.animation_data.resource_local_to_scene = true
		animation_data.sprite_height = varsTracker.DefaultSpriteHeight
		animation_data.sprite_width = varsTracker.DefaultSpriteHeight
		animation_data.resource_name = name.replace(" ", "") + "AnimationData"
		animation_data.character_name = name
		animation_data.char_file_name = name.replace(" ","") + ".tscn"
		
		# Pack & save the character to the Character Directory as a new .tscn file
		var packed_character = PackedScene.new()
		if !varsTracker.CharacterDirectory:
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.INVALID_DIRECTORY, self)
			return false
		if !packed_character.pack(new_character) == OK:
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.PROBLEM_PACKING_CHARCTER, self)
			return false
		if (
			ResourceSaver.save(char_filepath + ".tscn", packed_character) == OK
			and ResourceSaver.save(char_filepath + "AnimationData.tres", animation_data) == OK
		):
			varsTracker.CharacterList.append(name)
			save_varsTracker()
#			ResourceSaver.save("res://addons/Autoanim/Resources/AutoAnimVarsTracker.tres", varsTracker)
			if !varsTracker.CharacterList.has(name):
				emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.PROBLEM_ADDING_CHARACTER, self)
				return false
		
		else:
			emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.PROBLEM_ADDING_CHARACTER, self)
			return false
		# Set up the reference variables
		new_character.animTree = new_character.get_node("AnimationTree")
		new_character.animPlayer = new_character.get_node("AnimationPlayer")
		pack_and_save_character(new_character)
		populate_states_adr(new_character)
		save_character_adr(new_character)
		save_varsTracker()
		assert(new_character.animTree, "%s does not have an animTree properly assigned." % new_character.character_name)
		
	return true
#		assert(ResourceSaver.save("res://addons/Autoanim/Resources/VarsTracker.gd", varsTracker), "Saving varsTracker failed.")


func pack_and_save_character(character :OverworldCharacter) -> bool:
	var character_name := character.character_name
	var packed_character = PackedScene.new()
	var char_filepath := varsTracker.CharacterDirectory.plus_file(character_name.replace(" ", "") + ".tscn")
	
	# Return false if the Character Directory is not set
	if !varsTracker.CharacterDirectory:
		emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.INVALID_DIRECTORY, self)
		return false
	
	# Return false if character fails to pack
	if !packed_character.pack(character) == OK:
		emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.PROBLEM_PACKING_CHARCTER, self)
		return false
	
	if (ResourceSaver.save(char_filepath, packed_character) == OK):
		var dir := Directory.new()
		if !varsTracker.CharacterList.has(character_name):
			varsTracker.CharacterList.append(character_name)
			save_varsTracker()
#			ResourceSaver.save("res://addons/Autoanim/Resources/AutoAnimVarsTracker.tres", varsTracker)
	if !varsTracker.CharacterList.has(character_name):
		emit_signal("character_not_added", CHARACTER_CREATION_ERRORS.PROBLEM_ADDING_CHARACTER, self)
		return false
	return true


func create_animation(animation_name :String, character :OverworldCharacter) -> Animation:
	# Creates a new animation to be added to a given chracter's animation player
	# to be used in a BlendSpace2D as the parameter for an AnimationNode on the tree
	var new_animation := Animation.new()
	var character_adr :AnimationData = load(character.animation_data)
	var tracks_to_add :Dictionary = character_adr.tracks
	
	# Initialize timestamp, frame, and track index
	var timestamp := 0.0
	var frame := 0
	
	for track_index in tracks_to_add.size():
		var i = track_index - 1
		new_animation.add_track(i, tracks_to_add.values()[i])
	
	
	return new_animation
	
func populate_states_adr(character :OverworldCharacter) -> void:
	var anim_tree :AnimationTree = character.get_node("AnimationTree")
	character.animTree = anim_tree
	assert(anim_tree, "AnimTree not found on %s" % character.character_name)
	var state_machine :AnimationNodeStateMachine =  anim_tree.tree_root.get_node("StateMachine")
	var animation_data :AnimationData = ResourceLoader.load(varsTracker.CharacterDirectory.plus_file(character.character_name.replace(" ","") + "AnimationData.tres"))
	animation_data.states.clear()
	for prop_dict in state_machine.get_property_list():
		var prop_name = prop_dict.get('name')
		if prop_name.find('/node') > -1:
	#		var nd :AnimationNode = state_machine.get(prop_name)
			var state :String = str(prop_name).replace("states/", "").replace("/node", "")
			if !varsTracker.AnimationStatesList.has(state):
				varsTracker.AnimationStatesList.append(state)
			if !animation_data.states.has(state):
				animation_data.states.append(state)
	save_character_adr(character)
	character.animation_data = animation_data
	pack_and_save_character(character)
	
func generate_animation(animation_name :String, animation_direction :int) -> Animation:
	var anim_to_add := Animation.new()
	# The animation will handle changing: 
	## - the texture of the sprite
	## - the vframes and hframes of the sprite
	## - the the frame of the sprite
	
	
	# SET UP ANIMATION TRACKS
	for track in varsTracker.tracks:
		var track_index := 0
		anim_to_add.add_track(Animation.TYPE_VALUE, track_index)
		anim_to_add.track_set_path(track_index, track)
		track_index += 1
		match track:
			"texture":
				pass
	
	return anim_to_add

func setup_animation_tree(character :OverworldCharacter) -> void:
	character.animTree = character.get_node("AnimationTree")
	var anim_tree = character.animTree
	anim_tree.tree_root = auto_anim_tree_root
	anim_tree.active = true

func setup_blend_tree(node :String, directions :Array) -> void:
	pass

## SAVING FUNCTIONS
func save_character_adr(character :OverworldCharacter) -> void:
	assert(
		ResourceSaver.save(
			varsTracker.CharacterDirectory.plus_file(
				character.character_name.replace(" ","") + "AnimationData.tres"),
				character.animation_data)
			== OK,
		"SAVING %s AnimationData FAILED" % character.character_name)

func save_varsTracker():
	assert(ResourceSaver.save(varsTrackerPath, varsTracker) == OK, "SAVING varsTracker FAILED")



## LOAD/SAVE BUG FIX FUNCTIONS
static func make_random_path(file_type :String) -> String:
	return "res://addons/Autoanim/Resources/temp/" + str(randi()) + file_type
	
static func character_exists(path :String) -> bool:
	return ResourceLoader.exists(path)


## SETTERS AND GETTERS
func set_sprite_height(value :int) -> void:
	sprite_height = value
	varsTracker.DefaultSpriteHeight = value
	save_varsTracker()
	
func set_sprite_width(value :int) -> void:
	sprite_width = value
	varsTracker.DefaultSpriteWidth = value
	save_varsTracker()

func set_direction_set(value :int) -> void:
	direction_set = value
	varsTracker.DefaultDirectionSet = value
#	emit_signal("direction_set_chosen", value)
	save_varsTracker()
	
