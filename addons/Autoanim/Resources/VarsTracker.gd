tool
class_name VarsTracker extends Resource

enum DirectionSets {FDTD = 0, FDIS = 1, EDTD = 2, TDPF = 3}
enum Directions {SOUTH, SOUTHEAST, EAST, NORTHEAST, NORTH, NORTHWEST, WEST, SOUTHWEST }

export var CharacterList := [] 
export var AnimationStatesList := []
export var CharacterDirectory := ""
export var AssetDirectory := ""
export var DefaultSpriteHeight := 0
export var DefaultSpriteWidth := 0
export var DefaultDirectionSet := 0 setget set_default_direction_set
export var DefaultDirections := []

func set_default_direction_set(value) -> void:
	match value:
		DirectionSets.FDTD:
			DefaultDirections = [
				Directions.SOUTH,
				Directions.EAST,
				Directions.NORTH,
				Directions.WEST
			]
		DirectionSets.FDIS:
			DefaultDirections = [
				Directions.SOUTHEAST,
				Directions.NORTHEAST,
				Directions.NORTHWEST,
				Directions.SOUTHWEST
			]
		DirectionSets.EDTD:
			DefaultDirections = [
				Directions.SOUTH,
				Directions.SOUTHEAST,
				Directions.EAST,
				Directions.NORTHEAST,
				Directions.NORTH,
				Directions.NORTHWEST,
				Directions.WEST,
				Directions.SOUTHWEST
			]
		DirectionSets.TDPF:
			DefaultDirections = [
				Directions.EAST,
				Directions.WEST
			]
		_:
			DefaultDirections = []
			
	ResourceSaver.save("res://addons/Autoanim/Resources/AutoAnimVarsTracker.tres", self)
	print(DefaultDirections)
	
