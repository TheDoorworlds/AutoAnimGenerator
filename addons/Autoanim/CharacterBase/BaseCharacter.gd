tool
class_name OverworldCharacter extends KinematicBody2D

export var CharacterName := "Default"


var animPlayer :AnimationPlayer
var animTree :AnimationTree
var sprite :Sprite
var collisionShape2D :CollisionShape2D
var collisionShapeShape :CapsuleShape2D
export(Resource) var animation_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
