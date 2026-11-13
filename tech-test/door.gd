extends Node3D
@onready var collider: CSGBox3D = $collider


@export var TargetPosition: Vector3
@export var TargetRotationDeg: float
@export var toggle = false
@onready var closedPosition = position
@onready var closedRotation = rotation
@onready var openPosition = closedPosition + TargetPosition
@onready var openRotation = closedRotation + Vector3(0, deg_to_rad(TargetRotationDeg), 0)
@export var openCloseTime = 1.0 #Speed variable for lerping.
var timeElapsed = 1.0
var hP = closedPosition
var hR = closedRotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeElapsed += delta
	var tP
	var sP
	var tR
	var sR
	if (toggle):
		tP = openPosition
		sP = closedPosition
		tR = openRotation
		sR = closedRotation
	else:
		tP = closedPosition
		sP = openPosition
		tR = closedRotation
		sR = openRotation
	if (tP != hP || tR != hR):
		timeElapsed = 0.0
	if timeElapsed < openCloseTime:
		var weight: float = clamp(timeElapsed / openCloseTime, 0.0, 1.0)
		position = sP.lerp(tP, weight)
		rotation = sR.lerp(tR, weight)
	hP = tP
	hR = tR
