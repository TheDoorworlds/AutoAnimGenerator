tool
class_name AutoAnimToolMenu extends Popup

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var opt_DirectionSetDefault :OptionButton = get_node("MarginContainer/VBOX_MAIN/HBOX_DIRECIONSET/opt_DirectionSet")
onready var spin_SpriteHeightDefault :SpinBox = get_node("MarginContainer/VBOX_MAIN/HBOX_SPRITESIZE/spin_SpriteHeight")
onready var spin_SpriteWidthDefault :SpinBox = get_node("MarginContainer/VBOX_MAIN/HBOX_SPRITESIZE/spin_SpriteWidth")
onready var btn_CloseDefaults :Button = get_node("MarginContainer/VBOX_MAIN/btn_Close")
onready var btn_OpenBaseCharacter :Button = get_node("MarginContainer/VBOX_MAIN/btn_OpenBaseCharacter")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
