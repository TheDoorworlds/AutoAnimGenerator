## THIS SCRIPT HANDLES ALL COMMUNICATION BETWEEN THE UI (GenerateAnimsControl.tscn) AND THE ANIMATION GENERATOR (AnimationGenerator.gd)


tool
extends EditorPlugin


## SCENE AND RESOURCE REFERENCES
 # Main interface for the plugin
var main = preload("res://addons/Autoanim/Scenes/AutoAnimsMain.tscn")
var main_ins :Control
 # Base character, unused at this time
#var base_character = preload("res://addons/Autoanim/CharacterBase/BaseCharacter.tscn")
 # Make a new instance of the AnimationGenerator
var AnimGenerator :AnimationGenerator = AnimationGenerator.new()

 # Ease-of-access reference to the plugin's GUI
var GUI :GenerateAnimsGUI

# Ease-of-access wars to the editor segments
var editor_interface := get_editor_interface()
var file_system_dock :FileSystemDock = get_editor_interface().get_file_system_dock()
var file_system :EditorFileSystem = get_editor_interface().get_resource_filesystem()

# Character list management references
var btn_CharacterList := preload("res://addons/Autoanim/Scenes/CharacterListButton.tscn")

# States management references
var btn_StateButton := preload("res://addons/Autoanim/Scenes/StateButton.tscn")


## Character Vars
var character_name :String = ""
var char_filename :String = ""
var char_filepath :String = ""



## SETUP FUNCTIONS FOR ADDON
func has_main_screen() -> bool:
	return true

func get_plugin_name() -> String:
	return "AutoAnim"

func get_plugin_icon() -> Texture:
	return editor_interface.get_base_control().get_icon("Animation", "EditorIcons")

func make_visible(visible: bool) -> void:
	if main_ins:
		main_ins.visible = visible

func _enter_tree() -> void:
	main_ins = main.instance()
	GUI = main_ins
	editor_interface.get_editor_viewport().add_child(main_ins)
	make_visible(false)
	_connect_signals()
	toggled_disabled_buttons_for_character(GUI.line_CharacterName.text)
	
func _ready() -> void:
	GUI.lbl_AssetDir.text = AnimGenerator.varsTracker.AssetDirectory if AnimGenerator.varsTracker.AssetDirectory != "" else "Please set a Spritesheet Directory"
	GUI.lbl_CharacterDir.text = AnimGenerator.varsTracker.CharacterDirectory if AnimGenerator.varsTracker.CharacterDirectory != "" else "Please set a Character Scenes Directory"
	if !GUI.lbl_AssetDir.text.begins_with("res") or !GUI.lbl_CharacterDir.text.begins_with("res"):
		GUI.lbl_AddCharacterResults.text = "Please set both your Character and Asset directories..."
		GUI.lbl_AddCharacterResults.self_modulate = Color.aquamarine
	else:
		_reset_GUI_text(GUI.lbl_AddCharacterResults)
		_reset_GUI_text(GUI.lbl_CharacterCount, str(AnimGenerator.varsTracker.CharacterList.size()))
	_setup_character_list()
	_verify_characters()
		
func _exit_tree() -> void:
	if main_ins:
		main_ins.queue_free()
		GUI = null

func _connect_signals() -> void:
	GUI.btn_SetAssetDir.connect("pressed", self, "_on_SetAssetDirectory_pressed")
	GUI.btn_SetCharacterDir.connect("pressed", self, "_on_SetCharacterDirectory_pressed")
	GUI.btn_AddCharacter.connect("pressed", self, "_on_AddCharacter_pressed")
	GUI.btn_PullCharacer.connect("pressed", self, "_on_PullCharacter_pressed")
	GUI.btn_GenerateAnimations.connect("pressed", self, "_on_GenerateAniamtions_pressed")
	GUI.btn_ResetButton.connect("pressed", self, "_on_ResetButton_pressed")
	GUI.btn_RemoveCharacter.connect("pressed", self, "_on_RemoveCharacter_pressed")
	GUI.btn_OpenCharacterScene.connect("pressed", self, "_on_OpenCharacterScene_pressed")
	GUI.btn_RefreshCharacterList.connect("pressed", self, "_on_RefreshCharacterList_pressed")
	GUI.btn_UpdateStates.connect("pressed", self, "_on_UpdateStates_pressed")
	GUI.CharacterDirectoryPopup.connect("dir_selected", self, "_on_CharacterDirectorySelected")
	GUI.AssetDirectoryPopup.connect("dir_selected", self, "_on_AssetDirectorySelected")
#	GUI.ConfirmationDialoguePopup.connect("confirmed", self, "_on_ConfirmationDialogue_confirmed")
	GUI.line_CharacterName.connect("text_changed", self, "_on_CharacterNameLine_changed")
	AnimGenerator.connect("character_not_added", self, "_on_AnimGenerator_character_not_added")
	for button in GUI.vbox_CharacterList.get_children():
		button.connect("toggled", self, "_on_CharacterListButton_toggled", [button])

func _setup_character_list() -> void:
	if AnimGenerator.varsTracker.CharacterList.size() > 0:
		for character in AnimGenerator.varsTracker.CharacterList:
			var new_button := btn_CharacterList.instance()
			new_button.name = "btn_" + character.replace(" ", "")
			new_button.text = character
			new_button.connect("toggled", self, "_on_CharacterListButton_toggled", [new_button])
			GUI.vbox_CharacterList.add_child(new_button)

func _verify_characters() -> bool:
	var dir := Directory.new()
	if AnimGenerator.varsTracker.CharacterDirectory:
		var char_directory := AnimGenerator.varsTracker.CharacterDirectory
		for character in AnimGenerator.varsTracker.CharacterList:
			if !dir.file_exists(char_directory.plus_file(character.replace(" ","") + ".tscn")):
				print("Character '%s' scene not found!  Please manually check your Character Directory!")
				
				### Perhaps popup an interface to ask how the use wants to reconcile the data?
				return false
				
				
			if !dir.file_exists(char_directory.plus_file(character.replace(" ","") + "AnimationData.tres")):
				print("Character '%s' Animation Data not found!  Please manually check your Character Directory!")
				
				### Perhaps popup an interface to create the data file?
				return false
	else:
		print("Character Directory not yet set!  Please set in the AutoAnim interface.")
	print("All characters in Character List accounted for.")
	return true


# GUI SET FUNCTIONS
# These functions will update the display of the GUI
func _reset_GUI_text(label :Label, initial_text :String = "") -> void:
	label.text = initial_text
	label.self_modulate = Color.white

func reset_GUI_to_default() -> void:
	for child in GUI.get_node("ScrollContainer/HBOX_LAYOUT/GenerateAnimsControl/GENERATION_PANEL").get_children():
		if child is Label:
			if child.name.begins_with("lbl_"):
				if !child.name.ends_with("Directory"):
					_reset_GUI_text(child)
	_reset_GUI_text(GUI.lbl_CharacterOutput)
	_reset_GUI_text(GUI.lbl_CharacterInfoHeader, "Character Info for: ")
	for child in GUI.grid_StatesButtonGrid.get_children():
		child.queue_free()

func toggled_disabled_buttons_for_character(character_name :String) -> void:
	# Toggles GUI button states based on provided text in the Character Line Edit
	if AnimGenerator.varsTracker.CharacterList.has(character_name):
		GUI.btn_AddCharacter.disabled = true
		GUI.btn_PullCharacer.disabled = false
		GUI.btn_RemoveCharacter.disabled = false
		GUI.btn_OpenCharacterScene.disabled = false
		GUI.btn_UpdateStates.disabled = false
	else:
		GUI.btn_AddCharacter.disabled = false
		GUI.btn_PullCharacer.disabled = true
		GUI.btn_RemoveCharacter.disabled = true
		GUI.btn_OpenCharacterScene.disabled = true
		GUI.btn_UpdateStates.disabled = true



# NON-VOID, NON-BOOL RETURNS
func get_states_from_character(character :OverworldCharacter) -> Array:
	var states_array := []
	var anim_tree :AnimationTree = character.get_node("AnimationTree")
	var state_machine :AnimationNodeStateMachine = anim_tree.tree_root.get_node("StateMachine")
	for prop_dict in state_machine.get_property_list():
		var prop_name = prop_dict.get('name')
		if prop_name.find('/node') > -1:
#			var nd :AnimationNode = state_machine.get(prop_name)
			var state :String = str(prop_name).replace("states/", "").replace("/node", "")
			states_array.append(state)
			if !AnimGenerator.varsTracker.AnimationStatesList.has(state):
				AnimGenerator.varsTracker.AnimationStatesList.append(state)
				AnimGenerator.save_varsTracker()
	_refresh_states_buttons(states_array)
	print(states_array)
	return states_array


## SUPPORT FUNCTIONS
func _refresh_states_buttons(states :Array) -> void:
	if char_filepath != "" and char_filename.is_valid_filename():
		for child in GUI.grid_StatesButtonGrid.get_children():
			child.queue_free()
		var character :OverworldCharacter = load(char_filepath).instance()
		for state in states:
			var new_button := btn_StateButton.instance()
			new_button.text = str(state)
			new_button.connect("pressed", self, "_on_StateButton_pressed", [character, state])
			GUI.grid_StatesButtonGrid.add_child(new_button)
	
func pull_character(character_name :String) -> Dictionary:
	var character :OverworldCharacter = load(char_filepath).instance()
	var character_data := {}
	var character_adr :AnimationData = load(AnimGenerator.varsTracker.CharacterDirectory.plus_file(char_filename) + "AnimationData.tres")
	var character_adr_vars :Array
	if !AnimGenerator.varsTracker.CharacterList.has(character_name):
#		print("Character '%s' not found in character list on AutoAnimVarsTracker!" % character_name)
		return {}
	var character_plist :Array = character_adr.get_property_list()
	for property in character_plist:
#		print("CHECKING PROPERTY: ", property)
		for key in property.keys():
			if key == "usage":
				if property["usage"] == 8199:
#					print("Property 'usage' value == 8199 ")
					character_adr_vars.append(property["name"])
#					print("Added %s to character_adr_vars." % property["name"], "\n")
#				else:
#					print("Usage key was not 8199", "\n")
#			else:
#				print("Key '%s' was not 'usage'." % key)
#	print("Character Animation Data vars: ", character_adr_vars, "\n")
	for variable in character_adr_vars:
		for index in character_adr_vars.size():
			character_data[variable] = character_adr.get_property_value(variable)
	_refresh_states_buttons(get_states_from_character(character))
#	print("Character Data: ", character_data)
	return character_data

func parse_character_data_for_output(character_data :Dictionary) -> String:
	# Returns a string of parsed-out information.
	# This function has been separated out for EOA
	var output_text :String = ""
	for item in character_data:
		output_text += str(item) + ": " + str(character_data[item]) + "\n"
	return output_text



# BOOL RETURNS
func remove_character(character_name :String) -> bool:
	# Returns `true` when a character has been successfully removed, `false` when removal fails.
	var char_filename := character_name.replace(" ","")
	var char_filepath := AnimGenerator.varsTracker.CharacterDirectory.plus_file(char_filename) + ".tscn"
	var char_adr_path := AnimGenerator.varsTracker.CharacterDirectory.plus_file(char_filename) + "AnimationData.tres"
	var dir :Directory = Directory.new()
	GUI.ConfirmationDialoguePopup.dialog_text = "Delete character '%s'?" % character_name
	var editor_viewport_rect = editor_interface.get_viewport().get_visible_rect()
	GUI.ConfirmationDialoguePopup.popup(
			Rect2(
				editor_viewport_rect.size.x / 2 - ((editor_viewport_rect.size.x / 6)/2),
				editor_viewport_rect.size.y / 2 - ((editor_viewport_rect.size.x / 6)/2),
				editor_viewport_rect.size.x / 6,
				editor_viewport_rect.size.y / 6
			)
		)
	yield(GUI.ConfirmationDialoguePopup, "confirmed")
#	print("Directory exists before change: " , dir.dir_exists(AnimGenerator.varsTracker.CharacterDirectory))
	dir.change_dir(AnimGenerator.varsTracker.CharacterDirectory)
	print(" Checking for ", char_filepath)
	if dir.file_exists(char_filepath):
		print("File %s found.  Attemping removal..." % char_filepath)
		dir.remove(char_filepath)
		file_system.scan()
		editor_interface.get_inspector().refresh()
#		yield(get_editor_interface().get_file_system_dock(), "file_removed")
		if !dir.file_exists(char_filepath):
			print("   Successfully removed %s." % char_adr_path)
			if ResourceLoader.exists(char_adr_path):
				print("File %s found.  Attemping removal..." % char_adr_path)
				dir.remove(char_adr_path)
#				yield(get_editor_interface().get_file_system_dock(), "file_removed")
				if !dir.file_exists(char_adr_path):
					print("   Successfully removed %s." % char_adr_path)
					AnimGenerator.varsTracker.CharacterList.remove(AnimGenerator.varsTracker.CharacterList.find(character_name))
					if !AnimGenerator.varsTracker.CharacterList.has(character_name):
						print("SUCCESSFULLY REMOVED ", character_name)
#						print("    Character List Before save:" , AnimGenerator.varsTracker.CharacterList)
						editor_interface.get_inspector().refresh()
#						print("     Character List After save: ", AnimGenerator.varsTracker.CharacterList)
						## Removes button from character list
						var button := GUI.vbox_CharacterList.get_node("btn_%s" % char_filename)
#						assert(button, "Button '%s' not found" % "btn_" + char_filename)
						GUI.vbox_CharacterList.remove_child(button)
						button.queue_free()
						toggled_disabled_buttons_for_character(character_name)
						AnimGenerator.save_varsTracker()
#						ResourceSaver.save("res://addons/Autoanim/Resources/", AnimGenerator.varsTracker)
						return true
				else:
					print("File not removed: ", char_adr_path)
			else:
				print(char_adr_path, " not found.")
		else:
			print("File not removed: ", char_filepath)
	else:
		print("Did not find ", char_filepath)
	print("Failed to remove ", character_name)
	return false


# SIGNAL RECEIVERS
func _on_AddCharacter_pressed() -> void:
	_reset_GUI_text(GUI.lbl_AddCharacterResults)
	char_filename = GUI.line_CharacterName.text.replace(" ","")
	if char_filename.is_valid_filename():
		if character_name != null:
			print("Adding character: ", char_filename)
			if AnimGenerator.setup_new_character(character_name):
				ResourceLoader.load("res://addons/Autoanim/Resources/AutoAnimVarsTracker.tres")
				editor_interface.get_inspector().refresh()
				GUI.lbl_AddCharacterResults.text = "Character '%s' Successfully Added!" % character_name
				GUI.lbl_AddCharacterResults.self_modulate = Color.green
				GUI.lbl_CharacterCount.text = str(AnimGenerator.varsTracker.CharacterList.size())
				toggled_disabled_buttons_for_character(character_name)
		## Adds button to character list
		var new_button := btn_CharacterList.instance()
		new_button.name = "btn_" + char_filename
		new_button.text = character_name
		new_button.connect("toggled", self, "_on_CharacterListButton_toggled", [new_button])
		GUI.vbox_CharacterList.add_child(new_button)
		pull_character(character_name)
	else:
		GUI.lbl_AddCharacterResults.text = "Cannot add character.  Invalid name."
		GUI.lbl_AddCharacterResults.self_modulate = Color.red

func _on_PullCharacter_pressed() -> void:
	reset_GUI_to_default()
	var output_text :String = parse_character_data_for_output(pull_character(character_name))
	GUI.lbl_CharacterOutput.text = output_text
	GUI.lbl_CharacterInfoHeader.text = "Character Info For: " + character_name

func _on_RemoveCharacter_pressed() -> void:
	if remove_character(character_name):
		yield(GUI.ConfirmationDialoguePopup, "confirmed")
		reset_GUI_to_default()
		GUI.lbl_AddCharacterResults.text = "%s successfully removed." % character_name
		GUI.lbl_CharacterCount.text = str(AnimGenerator.varsTracker.CharacterList.size())
		GUI.lbl_AddCharacterResults.self_modulate = Color.green
		
	else:
		GUI.lbl_AddCharacterResults.text = "Failed to remove %s" % character_name
		GUI.lbl_AddCharacterResults.self_modulate = Color.red
		
		
func _on_CharacterListButton_toggled(_button_pressed :bool, toggled_button :Button) -> void:
	GUI.line_CharacterName.text = toggled_button.text
	GUI.line_CharacterName.emit_signal("text_changed", toggled_button.text)
	toggled_disabled_buttons_for_character(character_name)

func _on_RefreshCharacterList_pressed() -> void:
	for child in GUI.vbox_CharacterList.get_children():
		child.queue_free()
	_setup_character_list()
	GUI.lbl_CharacterCount.text = str(AnimGenerator.varsTracker.CharacterList.size())
		
func _on_AnimGenerator_character_exists() -> void:
	GUI.lbl_AddCharacterResults.self_modulate = Color.green
	GUI.lbl_AddCharacterResults.text = "Character already exists!"
	

func _on_SetCharacterDirectory_pressed() -> void:
	GUI.CharacterDirectoryPopup.dialog_text = "Please select the directory where you store your Character Scenes"
	GUI.CharacterDirectoryPopup.popup_centered(Vector2(500,500))


func _on_CharacterDirectorySelected(path :String) -> void:
	GUI.lbl_CharacterDir.text = path
	AnimGenerator.varsTracker.CharacterDirectory = path
	ResourceSaver.save("res://addons/Autoanim/Resources/VarsTracker.gd", AnimGenerator.varsTracker)
	if !GUI.lbl_AssetDir.text.begins_with("res") or !GUI.lbl_CharacterDir.text.begins_with("res"):
		GUI.lbl_AddCharacterResults.text = "Please set both your Character and Asset directories..."
		GUI.lbl_AddCharacterResults.self_modulate = Color.aquamarine
	else:
		_reset_GUI_text(GUI.lbl_AddCharacterResults)

func _on_SetAssetDirectory_pressed() -> void:
	GUI.AssetDirectoryPopup.dialog_text = "Please select the directory where you store your spritesheets"
	GUI.AssetDirectoryPopup.popup_centered(Vector2(500,500))

func _on_AssetDirectorySelected(path :String) -> void:
	GUI.lbl_AssetDir.text = path
	AnimGenerator.varsTracker.AssetDirectory = path
	ResourceSaver.save("res://addons/Autoanim/Resources/VarsTracker.gd", AnimGenerator.varsTracker)
	if !GUI.lbl_AssetDir.text.begins_with("res") or !GUI.lbl_CharacterDir.text.begins_with("res"):
		GUI.lbl_AddCharacterResults.text = "Please set both your Character and Asset directories..."
		GUI.lbl_AddCharacterResults.self_modulate = Color.aquamarine
	else:
		_reset_GUI_text(GUI.lbl_AddCharacterResults)
		
		
func _on_CharacterNameLine_changed(new_text :String) -> void:
	character_name = new_text
	char_filename = new_text.replace(" " ,"")
	char_filepath = AnimGenerator.varsTracker.CharacterDirectory.plus_file(char_filename + ".tscn")
	if new_text == "":
		GUI.btn_AddCharacter.disabled = true
		GUI.btn_PullCharacer.disabled = true
		GUI.btn_RemoveCharacter.disabled = true
		GUI.btn_UpdateStates.disabled = true
		return
	if !GUI.lbl_AssetDir.text.begins_with("res") or !GUI.lbl_CharacterDir.text.begins_with("res"):
		GUI.btn_AddCharacter.disabled = true
		GUI.btn_PullCharacer.disabled = true
		GUI.btn_RemoveCharacter.disabled = true
		GUI.btn_UpdateStates.disabled = true
		GUI.lbl_AddCharacterResults.text = "Please set both your Character and Asset directories..."
		GUI.lbl_AddCharacterResults.self_modulate = Color.aquamarine
		return
		
	toggled_disabled_buttons_for_character(new_text)
		

func _on_OpenCharacterScene_pressed() -> void:
	print("Open Character Scene pressed, opening file...")
	editor_interface.open_scene_from_path(AnimGenerator.varsTracker.CharacterDirectory.plus_file(character_name.replace(" ","") + ".tscn"))
	
		
func _on_AnimGenerator_character_not_added(error_code :int, originating_object) -> void:
	print("ERROR on %s: %s" % [originating_object, error_code])
	print("ERROR on %s: %s" % [originating_object, error_code])


func _on_UpdateStates_pressed() -> void:
	if char_filepath != "" and char_filename.is_valid_filename():
		var character_scene := load(char_filepath)
		var character :OverworldCharacter = character_scene.instance()
		_refresh_states_buttons(get_states_from_character(character))
		AnimGenerator.populate_states_adr(character)
		AnimGenerator.pack_and_save_character(character)





