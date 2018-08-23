extends Node2D

onready var animation = $Animation
var center
var offset
var game
var is_player_on_right = true

func _ready():
	game = get_parent()
	center = get_viewport_rect().size.x / 2
	offset = abs(position.x - center)
	connect("area_entered", self, "_on_area_entered")

func _input(event):
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		if event.position.x < center:
			position.x = center - offset
			scale.x = -abs(scale.x) #flips the sprite horizontally
			is_player_on_right = true
		else:
			position.x = center + offset
			scale.x = abs(scale.x) #flips the sprite horizontally
			is_player_on_right = false
		
		animation.play("punch")
		game.punch_tree(is_player_on_right)

func _on_area_entered(area):
	if area.is_in_group("Axes"):
		game.die()
	
	