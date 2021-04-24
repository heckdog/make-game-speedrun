extends KinematicBody2D


#variables
export var movespeed_x = 50
export var movespeed_y = 50

var screen_size

const Bubble = preload("res://scenes/Bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	screen_size = get_viewport_rect().size
	$BubbleTimer.connect("timeout", self, "_on_BubbleTimer_timeout")


# called every physics frame, which is before each drawn frame
func _physics_process(delta):
	var velocity = Vector2()
	var sink = Vector2(0,3)  # sinking vector
	
	velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * movespeed_x
	velocity.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * movespeed_y
	
	var move_vector = (velocity + sink)
	
	velocity = move_and_slide(move_vector)
	
	position.x = clamp(position.x, 0, screen_size.x)
	
	# animation
	var flip = velocity.x < 0
	$AnimatedSprite.flip_h = flip
	# slow animation if not moving
	if abs(velocity.x) > 0:
		$AnimatedSprite.animation = "swim_h"
	else:
		$AnimatedSprite.animation = "idle"

func _process(delta):
	pass
	
func _on_BubbleTimer_timeout():
	for i in range(3):
		var bub = Bubble.instance()
		bub.update_pos(Vector2($Sprite.position.x, $Sprite.position.y-9))  # this makes it local
		add_child(bub)
		yield(get_tree().create_timer(0.3),"timeout")  # wait
