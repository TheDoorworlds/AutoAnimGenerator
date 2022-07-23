tool
class_name OverworldCharacter extends KinematicBody2D

export var character_name := "Default"

## INTERNAL SCENE VARS
var animPlayer :AnimationPlayer
var animTree :AnimationTree
var sprite :Sprite
var collisionShape2D :CollisionShape2D
var collisionShapeShape :CapsuleShape2D
export(Resource) var animation_data
var state_machine :AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animTree = $AnimationTree # Replace with function body.
	animPlayer = $AnimationPlayer
	state_machine = animTree.get("parameters/playback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
