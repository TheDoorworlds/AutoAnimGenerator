tool
class_name GenerateAnimsGUI extends Control

var generation_panel_path := "ScrollContainer/HBOX_LAYOUT/GenerateAnimsControl/GENERATION_PANEL/"

onready var btn_SetCharacterDir :Button = get_node(generation_panel_path + "hbox_Directories/vbox_CharacterDirectory/btn_SetCharacterDirectory")
onready var lbl_CharacterDir :Label = get_node(generation_panel_path + "hbox_Directories/vbox_CharacterDirectory/lbl_CharacterDirectory")
onready var btn_SetAssetDir :Button = get_node(generation_panel_path + "hbox_Directories/vbox_AssetDirectory/btn_SetAssetDirectory")
onready var lbl_AssetDir :Label = get_node(generation_panel_path + "hbox_Directories/vbox_AssetDirectory/lbl_AssetDirectory")

# CHARACTER MANAGEMENT
onready var line_CharacterName :LineEdit = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/hbox_CharacterName/line_CharacterName")
onready var btn_AddCharacter :Button = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/hbox_CharacterButtons/btn_AddCharacter")
onready var btn_PullCharacer :Button = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/hbox_CharacterButtons/btn_PullCharacter")
onready var lbl_AddCharacterResults :Label = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/lbl_AddCharacterResults")
onready var lbl_CharacterOutput :Label = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo2/OutputPane/MarginContainer/lbl_CharacterOutputText")
onready var lbl_CharacterInfoHeader :Label = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo2/CHARACTER_INFO_HEADER")
onready var btn_RemoveCharacter :Button = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/btn_RemoveCharacter")
onready var btn_OpenCharacterScene :Button = get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/btn_OpenCharacterScene")

# ANIMATIONS MANAGEMENT
onready var btn_GenerateAnimations :Button = get_node(generation_panel_path + "btn_GenerateAnimations")
onready var lbl_GenerationResults :Label = get_node(generation_panel_path + "lbl_GenerateResult")
onready var btn_ResetButton :Button = get_node(generation_panel_path + "btn_Reset")

# STATES MANAGMENT
onready var btn_UpdateStates := get_node(generation_panel_path + "hbox_CharacterManagement/vbox_CharacterInfo/btn_PullStates")
onready var grid_StatesButtonGrid :GridContainer = get_node(generation_panel_path + "hbox_States/STATES_PANEL/vbox_CurrentStates/grid_StatesButtonGrid")

# INTERFACE MANAGEMENT
onready var lbl_CharacterCount := get_node("ScrollContainer/HBOX_LAYOUT/GenerateAnimsControl/CHARACTER_LIST_PANEL/CHARACTER_LIST/hbox_Counters/lbl_CharacterCount")
onready var vbox_CharacterList := get_node("ScrollContainer/HBOX_LAYOUT/GenerateAnimsControl/CHARACTER_LIST_PANEL/CHARACTER_LIST/opt_CharacterList/vbox_CharacterList")
onready var btn_RefreshCharacterList := get_node("ScrollContainer/HBOX_LAYOUT/GenerateAnimsControl/CHARACTER_LIST_PANEL/CHARACTER_LIST/btn_RefreshCharacterList")
onready var CharacterDirectoryPopup :FileDialog = get_node("CharacterDirectoryPopup")
onready var AssetDirectoryPopup :FileDialog = get_node("AssetDirectoryPopup")
onready var ConfirmationDialoguePopup :ConfirmationDialog = get_node("ConfirmationDialog")

export(Resource) var VarsTracker
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lbl_AddCharacterResults.text= ""
	lbl_AssetDir.text = ""
	lbl_CharacterDir.text = ""
	btn_AddCharacter.disabled = true
	btn_PullCharacer.disabled = true
	
	# Check the Character Base node for states in the state machine
	# create on btn_StateButton for each state and add as a child to grid_StatesButtonGrid
# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
