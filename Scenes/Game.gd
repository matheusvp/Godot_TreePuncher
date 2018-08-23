extends Node

export(PackedScene) var trunk_scene
onready var first_trunk_position = $FirstTrunkPosition
onready var grave = $Grave
onready var player = $Player
onready var restart_timer = $RestartTimer
onready var score_text = $Label
var last_spawn_pos
var trunks = []
var new_trunk_axe_on_right = false
var last_spawned_axe = 0
var score = 0

func _ready():
	print(10)
	last_spawn_pos = first_trunk_position.position
	_spawn_first_trunks()

func _process(delta):
	score_text.text = str(score)

func spawn_trunk(has_axe, right_side_axe):
	var newTrunk = trunk_scene.instance()
	add_child(newTrunk)
	newTrunk.position = last_spawn_pos
	#last_spawn_pos.y -= newTrunk.sprite_height
	newTrunk.initialize_trunk(has_axe, right_side_axe)
	trunks.append(newTrunk)
	
	# save last spawned axe position
	if !has_axe:
		last_spawned_axe = 0
	else:
		if right_side_axe:
			last_spawned_axe = 1
		else:
			last_spawned_axe = -1

func _spawn_first_trunks():
	for counter in range(5):
		var newTrunk = trunk_scene.instance()
		add_child(newTrunk)
		newTrunk.position = last_spawn_pos
		last_spawn_pos.y -= newTrunk.sprite_height
		newTrunk.initialize_trunk(false,false)
		trunks.append(newTrunk)
		#spawn_trunk(false,false)


func punch_tree(from_right):
	#spawn new trunk 
	if rand_range(0,100) > 30:
		#spawn with axe
		new_trunk_axe_on_right = rand_range(0,100) > 50
		if last_spawned_axe == 0 or (last_spawned_axe == 1 and new_trunk_axe_on_right):
			spawn_trunk(true,new_trunk_axe_on_right)
		else:
			spawn_trunk(false,false)
	else:
		#spawn without axe
		spawn_trunk(false,false)
		
	#remove punched trunk
	trunks[0].remove(from_right)
	trunks.pop_front()
	for trunk in trunks:
		trunk.position.y += trunk.sprite_height
		
	score += 1
		

func die():
	grave.position.x = player.position.x
	player.queue_free()
	grave.visible = true
	restart_timer.start()
	

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene()
