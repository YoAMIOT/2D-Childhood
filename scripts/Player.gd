extends KinematicBody2D

###Variables###
var walkSpeed : int = 50;
var runSpeed : int = walkSpeed * 2;
var velocity : Vector2 = Vector2.ZERO;
var isWalking : bool = false;
var lastDir : String = "down";
var actualDir : String = "";
var isRunning : bool = false;
var transportation : String = "walk";



###Process Function###
func _physics_process(delta):
	if Input.is_action_just_pressed("select_transportation"):
		if transportation == "walk":
			transportation = "bike";
		elif transportation == "bike":
			transportation = "walk";

	if transportation == "walk":
		animateOnFoot();
		getInputOnFoot();
	elif transportation == "bike":
		animateOnBike();
		getInputOnBike();

	velocity = move_and_slide(velocity);



###Function to get the input of the player on foot###
func getInputOnFoot():
	velocity = Vector2.ZERO;

	if Input.is_action_pressed("down"):
		velocity.y += 1;
		actualDir = "down";
		isWalking = true;
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		actualDir = "up";
		isWalking = true;
	if Input.is_action_pressed("right"):
		velocity.x += 1;
		actualDir = "right";
		isWalking = true;
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		actualDir = "left";
		isWalking = true;

	if Input.is_action_pressed("run"):
		isRunning = true;

	if Input.is_action_just_released("down"):
		isWalking = false;
		lastDir = "down";
	if Input.is_action_just_released("up"):
		isWalking = false;
		lastDir = "up";
	if Input.is_action_just_released("right"):
		isWalking = false;
		lastDir = "right";
	if Input.is_action_just_released("left"):
		isWalking = false;
		lastDir = "left";
	if Input.is_action_just_released("run"):
		isRunning = false;

	if isWalking == true and isRunning == false:
		velocity = velocity.normalized() * walkSpeed;
	elif isWalking == true and isRunning == true:
		velocity = velocity.normalized() * runSpeed;



###Function to animate the Animated Sprite by testing what the player is doing on foot###
func animateOnFoot():
	if isWalking == false:
		if isRunning:
			$AnimatedSprite.animation = "idle_impatient";
		elif lastDir == "down":
			$AnimatedSprite.animation = "idle_downward";
		elif lastDir == "up":
			$AnimatedSprite.animation = "idle_upward";
		elif lastDir == "right":
			$AnimatedSprite.animation = "idle_right";
		elif lastDir == "left":
			$AnimatedSprite.animation = "idle_left";

	elif isWalking == true:
		if velocity != Vector2(0, 0):
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

		elif velocity == Vector2(0, 0):
			if isRunning == false:
				$AnimatedSprite.animation = "idle_downward";
			if isRunning == true:
				$AnimatedSprite.animation = "idle_impatient";



###Function to get the input of the player on bike###
func getInputOnBike():
	velocity = Vector2.ZERO;

	if Input.is_action_just_released("down"):
		lastDir = "down";
	if Input.is_action_just_released("up"):
		lastDir = "up";
	if Input.is_action_just_released("right"):
		lastDir = "right";
	if Input.is_action_just_released("left"):
		lastDir = "left";



###Function to animate the Animated Sprite by testing what the player is doing on bike###
func animateOnBike():
	if velocity == Vector2(0, 0):
		if lastDir == "down":
			$AnimatedSprite.animation = "bike_idle_downward";
		elif lastDir == "up":
			$AnimatedSprite.animation = "bike_idle_upward";
		elif lastDir == "right":
			$AnimatedSprite.animation = "bike_idle_right";
		elif lastDir == "left":
			$AnimatedSprite.animation = "bike_idle_left";
	elif velocity != Vector2(0, 0):
		if actualDir == "down":
			$AnimatedSprite.animation = "bike_slow_pace_downward";
		elif actualDir == "up":
			$AnimatedSprite.animation = "bike_slow_pace_upward";
		elif actualDir == "right":
			$AnimatedSprite.animation = "bike_slow_pace_right";
		elif actualDir == "left":
			$AnimatedSprite.animation = "bike_slow_pace_left";
