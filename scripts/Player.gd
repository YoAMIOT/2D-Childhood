extends KinematicBody2D

###Variables###
var walkSpeed : int = 50;
var runSpeed : int = walkSpeed * 2;
var velocity : Vector2 = Vector2.ZERO;
var isWalking : bool = false;
var lastDir : String = "down";
var actualDir : String = "";
var isRunning : bool = false;



###Function to get the input of the player###
func getInput():
	velocity = Vector2.ZERO

	if Input.is_action_pressed("right"):
		velocity.x += 1;
		isWalking = true;
		actualDir = "right";
	if Input.is_action_just_released("right"):
		isWalking = false;
		lastDir = "right";

	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		isWalking = true;
		actualDir = "left";
	if Input.is_action_just_released("left"):
		isWalking = false;
		lastDir = "left";

	if Input.is_action_pressed("down"):
		velocity.y += 1;
		isWalking = true;
		actualDir = "down";
	if Input.is_action_just_released("down"):
		isWalking = false;
		lastDir = "down";

	if Input.is_action_pressed("up"):
		velocity.y -= 1
		isWalking = true;
		actualDir = "up";
	if Input.is_action_just_released("up"):
		isWalking = false;
		lastDir = "up";
	
	if Input.is_action_pressed("run"):
		isRunning = true;
	if Input.is_action_just_released("run"):
		isRunning = false;

	if isWalking == true and isRunning == false:
		velocity = velocity.normalized() * walkSpeed;
	elif isWalking == true and isRunning == true:
		velocity = velocity.normalized() * runSpeed;



###Process Function###
func _physics_process(delta):
	getInput();
	animate();

	velocity = move_and_slide(velocity);



###Function to animate the Animated Sprite by testing what the player is doing###
func animate():
	if isWalking == false:
		if lastDir == "down":
			$AnimatedSprite.animation = "idle_downward";
		elif lastDir == "up":
			$AnimatedSprite.animation = "idle_upward";
		elif lastDir == "right":
			$AnimatedSprite.animation = "idle_right";
		elif lastDir == "left":
			$AnimatedSprite.animation = "idle_left";
	elif isWalking == true:
		if isRunning == false:
			if actualDir == "down":
				$AnimatedSprite.animation = "downward_walk";
			elif actualDir == "up":
				$AnimatedSprite.animation = "upward_walk";
			elif actualDir == "right":
				$AnimatedSprite.animation = "right_walk";
			elif actualDir == "left":
				$AnimatedSprite.animation = "left_walk";
		elif isRunning == true:
			if actualDir == "down":
				$AnimatedSprite.animation = "downward_run";
			elif actualDir == "up":
				$AnimatedSprite.animation = "upward_run";
			elif actualDir == "right":
				$AnimatedSprite.animation = "right_run";
			elif actualDir == "left":
				$AnimatedSprite.animation = "left_run";
