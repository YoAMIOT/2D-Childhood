extends KinematicBody2D

#General Variables#
var velocity : Vector2 = Vector2.ZERO
var transportation : String = "walk";

#Walk Variables#
var walkSpeed : int = 50;
var runSpeed : int = walkSpeed * 2;
var isRunning : bool = false;
var actualDir : String = "down";

#Bike Variables#
var bikeSpeed : int = 10;
var virtualRotation : int = 180;
var bikeActualDir : String = "down";



#Process Function#
func _physics_process(delta):
	if Input.is_action_just_pressed("select_transportation") and velocity == Vector2(0, 0):
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



#Function to get the input of the player on foot#
func getInputOnFoot():
	velocity = Vector2.ZERO;

	if Input.is_action_pressed("down"):
		velocity.y += 1;
		actualDir = "down";
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		actualDir = "up";
	if Input.is_action_pressed("right"):
		velocity.x += 1;
		actualDir = "right";
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		actualDir = "left";
	if Input.is_action_pressed("run"):
		isRunning = true;
		velocity = velocity.normalized() * runSpeed;
	else:
		velocity = velocity.normalized() * walkSpeed;

	if Input.is_action_just_released("run"):
		isRunning = false;



#Function to animate the Animated Sprite by testing what the player is doing on foot#
func animateOnFoot():
	if velocity == Vector2(0, 0):
		if isRunning == true:
			$AnimatedSprite.animation = "foot_idle_impatient";
		elif actualDir == "down":
			$AnimatedSprite.animation = "foot_idle_downward";
		elif actualDir == "up":
			$AnimatedSprite.animation = "foot_idle_upward";
		elif actualDir == "right":
			$AnimatedSprite.animation = "foot_idle_right";
		elif actualDir == "left":
			$AnimatedSprite.animation = "foot_idle_left";

	if velocity != Vector2(0, 0):
		if isRunning == false:
			if actualDir == "down":
				$AnimatedSprite.animation = "foot_walk_downward";
			elif actualDir == "up":
				$AnimatedSprite.animation = "foot_walk_upward";
			elif actualDir == "right":
				$AnimatedSprite.animation = "foot_walk_right";
			elif actualDir == "left":
				$AnimatedSprite.animation = "foot_walk_left";
		elif isRunning == true:
			if actualDir == "down":
				$AnimatedSprite.animation = "foot_run_downward";
			elif actualDir == "up":
				$AnimatedSprite.animation = "foot_run_upward";
			elif actualDir == "right":
				$AnimatedSprite.animation = "foot_run_right";
			elif actualDir == "left":
				$AnimatedSprite.animation = "foot_run_left";



#Function to get the input of the player on bike#
func getInputOnBike():
	velocity = Vector2.ZERO;

	if Input.is_action_pressed("down"):
		pass;
	if Input.is_action_pressed("up"):
		pass;
	if Input.is_action_just_pressed("right"):
		virtualRotation += 30;
	if Input.is_action_just_pressed("left"):
		virtualRotation -= 30;

	if virtualRotation >= 360:
		virtualRotation = 0;
	if virtualRotation < 0:
		virtualRotation = 330;

	if virtualRotation == 0 or virtualRotation == 360:
		bikeActualDir = "up";
	elif virtualRotation == 30:
		bikeActualDir = "up_right";
	elif virtualRotation == 60:
		bikeActualDir = "right_up";
	elif virtualRotation == 90:
		bikeActualDir = "right";
	elif virtualRotation == 120:
		bikeActualDir = "right_down";
	elif virtualRotation == 150:
		bikeActualDir = "down_right";
	elif virtualRotation == 180:
		bikeActualDir = "down";
	elif virtualRotation == 210:
		bikeActualDir = "down_left";
	elif virtualRotation == 240:
		bikeActualDir = "left_down";
	elif virtualRotation == 270:
		bikeActualDir = "left";
	elif virtualRotation == 300:
		bikeActualDir = "left_up";
	elif virtualRotation == 330:
		bikeActualDir = "up_left";

	velocity = velocity.normalized() * bikeSpeed;



#Function to animate the Animated Sprite by testing what the player is doing on bike#
func animateOnBike():
	if velocity == Vector2(0, 0):
		#Down#
		if bikeActualDir == "down":
			$AnimatedSprite.animation = "bike_idle_downward";
		elif bikeActualDir == "down_right":
			$AnimatedSprite.animation = "bike_idle_downward_right";
		elif bikeActualDir == "down_left":
			$AnimatedSprite.animation = "bike_idle_downward_left";
		#Up#
		elif bikeActualDir == "up":
			$AnimatedSprite.animation = "bike_idle_upward";
		elif bikeActualDir == "up_right":
			$AnimatedSprite.animation = "bike_idle_upward_right";
		elif bikeActualDir == "up_left":
			$AnimatedSprite.animation = "bike_idle_upward_left";
		#Right#
		elif bikeActualDir == "right":
			$AnimatedSprite.animation = "bike_idle_right";
		elif bikeActualDir == "right_up":
			$AnimatedSprite.animation = "bike_idle_right_up";
		elif bikeActualDir == "right_down":
			$AnimatedSprite.animation = "bike_idle_right_down";
		#Left#
		elif bikeActualDir == "left":
			$AnimatedSprite.animation = "bike_idle_left";
		elif bikeActualDir == "left_up":
			$AnimatedSprite.animation = "bike_idle_left_up";
		elif bikeActualDir == "left_down":
			$AnimatedSprite.animation = "bike_idle_left_down";

	elif velocity != Vector2(0, 0):
		#Down#
		if bikeActualDir == "down":
			$AnimatedSprite.animation = "bike_slow_pace_downward";
		elif bikeActualDir == "down_right":
			$AnimatedSprite.animation = "bike_slow_pace_downward";
		elif bikeActualDir == "down_left":
			$AnimatedSprite.animation = "bike_slow_pace_downward";
		#Up#
		elif bikeActualDir == "up":
			$AnimatedSprite.animation = "bike_slow_pace_upward";
		elif bikeActualDir == "up_right":
			$AnimatedSprite.animation = "bike_slow_pace_upward";
		elif bikeActualDir == "up_left":
			$AnimatedSprite.animation = "bike_slow_pace_upward";
		#Right#
		elif bikeActualDir == "right":
			$AnimatedSprite.animation = "bike_slow_pace_right";
		elif bikeActualDir == "right_up":
			$AnimatedSprite.animation = "bike_slow_pace_right";
		elif bikeActualDir == "right_down":
			$AnimatedSprite.animation = "bike_slow_pace_right";
		#Left#
		elif bikeActualDir == "left":
			$AnimatedSprite.animation = "bike_slow_pace_left";
		elif bikeActualDir == "left_up":
			$AnimatedSprite.animation = "bike_slow_pace_left";
		elif bikeActualDir == "left_down":
			$AnimatedSprite.animation = "bike_slow_pace_left";
