@icon("res://textures/editor_icons/path-distance.svg")
class_name MovementComponent
extends Node
## Handles grid-based character movement using AStarGrid2D pathfinding.
##
## This component manages smooth movement interpolation and tile-approached detection.
## Requires parent to be a CharacterBody2D with proper collision setup.
##
## Features:
## - Configurable movement speed and smoothing
## - Automatic path following with obstacle avoidance
## - Built-in path failure detection
## - Tilemap coordinate system integration

### Public Properties ###
## Base movement speed (pixels/second) before modifiers
@export var speed : float = 75
## Acceleration smoothness (seconds). Lower = snappier, higher = smoother momentum.[br]Dude starts drifting when value ≥ ~33
@export var movement_smoothness : float = 27
## Distance threshold for tile approach detection (pixels)
@export var approach_threshold : float = 6

### Private State ###
var _path : Array[Vector2i] = []
var _current_step : int = 0
var _target_position : Vector2
var _direction : Vector2

@onready var _parent : CharacterBody2D = get_parent()
@onready var _tilemap : TileMapLayer = $"/root/Node2D/TileMap/ground"
@onready var _astar : Node = $"/root/Node2D/astargrid2d"

### Public API ###
func move_to_coord(to : Vector2i, partial_path : bool = false) -> void:
		_update_path(_tilemap.local_to_map(_parent.position), to, partial_path)

func move_to_nearest_tile(tiles : Array[Global.BuildableBase], partial_path : bool = false) -> void:
		var target = $%grid_utils.find_nearest_tile(
				_tilemap.local_to_map(_parent.position),
				tiles
		)
		_update_path(_tilemap.local_to_map(_parent.position), target, partial_path)

func stop_moving() -> void:
		_path = []

### Private Implementation ###
func _update_path(from : Vector2i, to : Vector2i, partial : bool) -> void:
		_path = _astar.request_path(from, to, partial)
		_current_step = 0
		
		if _path.is_empty():
				push_warning("No path found for %s to %s" % [_parent.name, to])

func _physics_process(delta : float) -> void:
		if _path.is_empty():
				_parent.velocity = Vector2.ZERO
				return

		# Movement calculation
		_target_position = _tilemap.map_to_local(_path[_current_step])
		_direction = (Vector2(_target_position) - _parent.position).normalized()
		
		_parent.velocity = lerp(
				_parent.velocity,
				_direction * speed,
				100*delta / movement_smoothness
		)

		# Path progression
		if _parent.position.distance_to(_target_position) <= approach_threshold:
				_current_step += 1
				if _current_step >= _path.size():
						_path.clear()

		# Final movement
		if _parent.velocity != Vector2.ZERO:
				_parent.move_and_slide()
				_parent.rotate_sprite(_direction)
