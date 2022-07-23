tool
class_name GenerateAnimsGUI extends Control

var generate_anims_control_path := "MAIN_SCROLL_CONTAINER/HBOX_LAYOUT/GenerateAnimsControl/"

# DIRECTORY COLLECTION
onready var btn_SetCharacterDir :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_DIRECTORIES/VBOX_CHARACTER_DIRECTORY/btn_SetCharacterDirectory")
onready var lbl_CharacterDir :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_DIRECTORIES/VBOX_CHARACTER_DIRECTORY/lbl_CharacterDirectory")
onready var btn_SetAssetDir :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_DIRECTORIES/VBOX_ASSET_DIRECTORY/btn_SetAssetDirectory")
onready var lbl_AssetDir :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_DIRECTORIES/VBOX_ASSET_DIRECTORY/lbl_AssetDirectory")

# CHARACTER MANAGEMENT
onready var line_CharacterName :LineEdit = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_CHARACTER_NAME/line_CharacterName")
onready var btn_AddCharacter :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_CHARACTER_BUTTONS/btn_AddCharacter")
onready var btn_PullCharacter :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_CHARACTER_BUTTONS/btn_PullCharacter")
onready var lbl_AddCharacterResults :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/lbl_AddCharacterResults")
onready var lbl_CharacterOutput :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_OUTPUT/OUTPUT_SCROLL_PANEL/OUTPUT_MARGIN_CONTAINER/lbl_CharacterOutputText")
onready var lbl_CharacterInfoHeader :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_OUTPUT/lbl_CharacterInfoHeader")
onready var btn_RemoveCharacter :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/btn_RemoveCharacter")
onready var btn_OpenCharacterScene :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_OPEN_PULL_RESET/btn_OpenCharacterScene")
onready var btn_ResetCharacter :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_OPEN_PULL_RESET/btn_ResetCharacter")

# ANIMATIONS MANAGEMENT
onready var btn_GenerateAnimations :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/btn_GenerateAnimations")
onready var lbl_GenerationResults :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/lbl_GenerateResult")
onready var btn_ResetButton :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/btn_Reset")

# STATES MANAGMENT
onready var btn_PullStates :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_CHARACTER_MANAGEMENT/VBOX_CHARACTER_INFO_INPUT/HBOX_OPEN_PULL_RESET/btn_PullStates")
onready var grid_StatesButtonGrid :GridContainer = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/STATES_PANEL/VBOX_CURRENT_STATES/grid_StatesButtonGrid")
onready var btn_ResetStates :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/STATES_PANEL/VBOX_CURRENT_STATES/btn_ResetStates")
onready var btn_ResetStatetoDefault :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/btn_ResetStatetoDefault")
onready var lbl_StateInfoHeader :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/lbl_StateInfoHeader")
onready var btn_EditState :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/btn_EditState")
onready var lbl_SpriteSize :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails/lbl_SpriteSize")
onready var lbl_FrameCount :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails/lbl_FrameCount")
onready var lbl_BlendTreeNodeCount :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails/lbl_BlendTreeNodeCount")
onready var lbl_BlendTreeTrisCount :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails/lbl_BlendTreeTrisCount")
onready var lbl_StateTransitions :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails/lbl_StateTransitions")
onready var grid_StateDetails :GridContainer = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/grid_StateDetails")

# TEXTURE MANAGEMENT
onready var trect_StateTexture :TextureRect = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/SCROLL_CONTAINER_STATES/HBOX_STATES_INFORMATION/VBOX_CURRENT_STATE_INFORMATION/HBOX_TEXTURE/trect_StateTexture")

# INTERFACE MANAGEMENT
onready var lbl_CharacterCount :Label = get_node(generate_anims_control_path + "CHARACTER_LIST_PANEL/CHARACTER_LIST/HBOX_COUNTERS/lbl_CharacterCount")
onready var vbox_CharacterList :VBoxContainer = get_node(generate_anims_control_path + "CHARACTER_LIST_PANEL/CHARACTER_LIST/CHARCTER_LIST_SCROLL_CONTAINER/vbox_CharacterList")
onready var btn_RefreshCharacterList :Button = get_node(generate_anims_control_path + "CHARACTER_LIST_PANEL/CHARACTER_LIST/btn_RefreshCharacterList")
onready var CharacterDirectoryPopup :FileDialog = get_node("CharacterDirectoryPopup")
onready var AssetDirectoryPopup :FileDialog = get_node("AssetDirectoryPopup")
onready var ConfirmationDialoguePopup :ConfirmationDialog = get_node("ConfirmationDialog")

# DEFAULTS REFERENCES
onready var lbl_DefaultDirectionSet :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/SCROLL_CONTAINER_DEFAULTS/DEFAULTS_MARGIN_CONTAINER/VBOX_DEFAULTS_INFORMATION/lbl_DefaultDirectionSet")
onready var grid_DefaultDirectionsInSet :GridContainer = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/SCROLL_CONTAINER_DEFAULTS/DEFAULTS_MARGIN_CONTAINER/VBOX_DEFAULTS_INFORMATION/grid_DefaultAnimations")
onready var lbl_DefaultSpriteSize :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/SCROLL_CONTAINER_DEFAULTS/DEFAULTS_MARGIN_CONTAINER/VBOX_DEFAULTS_INFORMATION/lbl_DefaultSpriteSize")
onready var grid_DefaultAnimations :GridContainer = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/SCROLL_CONTAINER_DEFAULTS/DEFAULTS_MARGIN_CONTAINER/VBOX_DEFAULTS_INFORMATION/grid_DefaultAnimations")
onready var lbl_DefaultFrameCount :Label = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/SCROLL_CONTAINER_DEFAULTS/DEFAULTS_MARGIN_CONTAINER/VBOX_DEFAULTS_INFORMATION/HBOX_DEFAULT_FRAME_CUONT/lbl_DefaultFrameCount")
onready var btn_EditDefaults :Button = get_node(generate_anims_control_path + "GENERATION_PANEL/HBOX_STATES/VBOX_DEFAULTS_INFO/btn_EditDefaults")


#export(Resource) var VarsTracker
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lbl_AddCharacterResults.text= ""
	lbl_AssetDir.text = ""
	lbl_CharacterDir.text = ""
	btn_AddCharacter.disabled = true
	btn_PullCharacter.disabled = true
	btn_ResetStates.disabled = true
	btn_ResetButton.disabled = true
	
	# Check the Character Base node for states in the state machine
	# create on btn_StateButton for each state and add as a child to grid_StatesButtonGrid
# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
