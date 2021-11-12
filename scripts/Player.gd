extends KinematicBody2D

#General Variables#
var velocity : Vector2 = Vector2.ZERO
var transportation : String = "walk";

#Walk Variables#
var walkSpeed : int = 50;
var runSpeed : int = walkSpeed * 2;
var isRunning : bool = false;
var footActualDir : String = "down";

#Bike Variables#
var bikeSpeed : float = 0;
var bikeMaxSpeed : int = 120;
var virtualRotation : int = 180;
var bikeAcceleration : float = 0.5;
var bikeBrake : float = 1.2;
var bikeFriction : float = 0.4;
var bikeActualDir : String = "down";
var movingBackward : bool = false;
var movingForward : bool = false;
var isAccelerating: bool = false;
var bikeBraking : bool = false;

#Longboard Variables#
var longboardSpeed : float = 0;
var longboardMaxSpeed : int = 130;
var longboardVirtualRotation : int = 180;
var longboardAcceleration : float = 0.5;
var longboardFriction : float = 0.4;
var longboardBrake : float = 1.2;
var longboardActualDir : String = "downward";
var longboardMovingForward : bool = false;
var isPushing : bool = false;
var doubleTapLeft : int = 0;
var doubleTapRight : int = 0;
var isBraking : bool = false;



#Process Function#
func _physics_process(delta):
	if Input.is_action_just_pressed("select_transportation"):
		if $Phone.visible == false:
			$Phone.visible = true;
		elif $Phone.visible == true:
			$Phone.visible = false;

	if transportation == "walk":
		animateOnFoot();
		getInputOnFoot();
	elif transportation == "bike":
		animateOnBike();
		getInputOnBike();
	elif transportation == "longboard":
		animateOnLongboard();
		getInputOnLongboard();

	velocity = move_and_slide(velocity);



#Function to switch mean of transportation#
func switchTransportation(var newTransportation : String):
	manageDirectionWhenSwitchingTransportation(transportation, newTransportation);
	$AnimatedSprite.speed_scale = 1;
	transportation = newTransportation;



#Function to manage and keep direction when switching between transportations#
func manageDirectionWhenSwitchingTransportation(var lastTransport : String, var transport : String):
	if lastTransport == "walk" and transport == "bike":
		if footActualDir == "down":
			virtualRotation = 180;
			bikeActualDir = "down";
		elif footActualDir == "up":
			virtualRotation = 0;
			bikeActualDir = "up";
		elif footActualDir == "right":
			virtualRotation = 90;
			bikeActualDir = "right";
		elif footActualDir == "left":
			virtualRotation = 270;
			bikeActualDir = "left";
	elif lastTransport == "walk" and transport == "longboard":
		if footActualDir == "down":
			longboardVirtualRotation = 180;
			longboardActualDir = "downward";
		elif footActualDir == "up":
			longboardVirtualRotation = 0;
			longboardActualDir = "upward";
		elif footActualDir == "right":
			longboardVirtualRotation = 90;
			longboardActualDir = "right";
		elif footActualDir == "left":
			longboardVirtualRotation = 270;
			longboardActualDir = "left";
	elif lastTransport == "bike" and transport == "walk":
		if bikeActualDir.begins_with("up"):
			footActualDir = "up";
		elif bikeActualDir.begins_with("down"):
			footActualDir = "down";
		elif bikeActualDir.begins_with("right"):
			footActualDir = "right";
		elif bikeActualDir.begins_with("left"):
			footActualDir = "left";
	elif lastTransport == "bike" and transport == "longboard":
		if bikeActualDir.begins_with("up"):
			longboardVirtualRotation = 0;
			longboardActualDir = "upward";
		elif bikeActualDir.begins_with("down"):
			longboardVirtualRotation = 180;
			longboardActualDir = "downward";
		elif bikeActualDir.begins_with("right"):
			longboardVirtualRotation = 90;
			longboardActualDir = "right";
		elif bikeActualDir.begins_with("left"):
			longboardVirtualRotation = 270;
			longboardActualDir = "left";
	elif lastTransport == "longboard" and transport == "bike":
		if longboardActualDir.begins_with("upward"):
			virtualRotation = 0;
			bikeActualDir = "up";
		elif longboardActualDir.begins_with("downward"):
			virtualRotation = 180;
			bikeActualDir = "down";
		elif longboardActualDir.begins_with("right"):
			virtualRotation = 90;
			bikeActualDir = "right";
		elif longboardActualDir.begins_with("left"):
			virtualRotation = 270;
			bikeActualDir = "left";
	elif lastTransport == "longboard" and transport == "walk":
		if longboardActualDir.begins_with("upward"):
			footActualDir = "up";
		elif longboardActualDir.begins_with("downward"):
			footActualDir = "down";
		elif longboardActualDir.begins_with("right"):
			footActualDir = "right";
		elif longboardActualDir.begins_with("left"):
			footActualDir = "left";



#Function to get the input of the player on foot#
func getInputOnFoot():
	velocity = Vector2.ZERO;

	if Input.is_action_pressed("down"):
		velocity.y += 1;
		footActualDir = "down";
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		footActualDir = "up";
	if Input.is_action_pressed("right"):
		velocity.x += 1;
		footActualDir = "right";
	if Input.is_action_pressed("left"):
		velocity.x -= 1;
		footActualDir = "left";
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
		elif footActualDir == "down":
			$AnimatedSprite.animation = "foot_idle_downward";
		elif footActualDir == "up":
			$AnimatedSprite.animation = "foot_idle_upward";
		elif footActualDir == "right":
			$AnimatedSprite.animation = "foot_idle_right";
		elif footActualDir == "left":
			$AnimatedSprite.animation = "foot_idle_left";

	if velocity != Vector2(0, 0):
		if isRunning == false:
			if footActualDir == "down":
				$AnimatedSprite.animation = "foot_walk_downward";
			elif footActualDir == "up":
				$AnimatedSprite.animation = "foot_walk_upward";
			elif footActualDir == "right":
				$AnimatedSprite.animation = "foot_walk_right";
			elif footActualDir == "left":
				$AnimatedSprite.animation = "foot_walk_left";
		elif isRunning == true:
			if footActualDir == "down":
				$AnimatedSprite.animation = "foot_run_downward";
			elif footActualDir == "up":
				$AnimatedSprite.animation = "foot_run_upward";
			elif footActualDir == "right":
				$AnimatedSprite.animation = "foot_run_right";
			elif footActualDir == "left":
				$AnimatedSprite.animation = "foot_run_left";



#Function to get the input of the player on bike#
func getInputOnBike():
	velocity = Vector2.ZERO;

	if Input.is_action_just_pressed("right"):
		virtualRotation += 30;
		setBikeRotation();
	if Input.is_action_just_pressed("left"):
		virtualRotation -= 30;
		setBikeRotation();

	if Input.is_action_pressed("up"):
		isAccelerating = true;
		if bikeSpeed <= bikeMaxSpeed:
			bikeSpeed += bikeAcceleration;
		elif bikeSpeed > bikeMaxSpeed:
			bikeSpeed = bikeMaxSpeed;
	elif Input.is_action_pressed("down"):
		if movingForward == true:
			bikeBraking = true;
			if bikeSpeed > 0:
				bikeSpeed -= bikeBrake;
			elif bikeSpeed < 0:
				bikeSpeed = 0;
				bikeBraking = false;
		if movingForward == false:
			velocity = manageBikeDirection() * -1;
			movingBackward = true;

	if bikeSpeed > 0:
		movingForward = true;
		velocity = manageBikeDirection();
		if isAccelerating == false:
			if bikeSpeed > 0:
				bikeSpeed -= bikeFriction;
			if bikeSpeed < 0:
				bikeSpeed = 0;
	elif bikeSpeed == 0:
		movingForward = false;
		$AnimatedSprite.speed_scale = 1;

	if Input.is_action_just_released("up"):
		isAccelerating = false;
	if Input.is_action_just_released("down"):
		bikeBraking = true;
		if bikeSpeed == 0:
			movingBackward = false;

	if movingForward:
		velocity = velocity.normalized() * bikeSpeed;
	if movingBackward == true:
		velocity = velocity.normalized() * 15;



#Function to handle the acceleration based on the direction for the bike#
func manageBikeDirection() -> Vector2:
	var bikeDirection : Vector2 = Vector2.ZERO;

	#Up#
	if bikeActualDir == "up":
		bikeDirection = Vector2(0, -1);
	elif bikeActualDir == "up_right":
		bikeDirection = Vector2(0.3, -0.7);
	elif bikeActualDir == "up_left":
		bikeDirection = Vector2(-0.3, -0.7);
	#Down#
	elif bikeActualDir == "down":
		bikeDirection = Vector2(0, 1);
	elif bikeActualDir == "down_right":
		bikeDirection = Vector2(0.3, 0.7);
	elif bikeActualDir == "down_left":
		bikeDirection = Vector2(-0.3, 0.7);
	#Right#
	elif bikeActualDir == "right":
		bikeDirection = Vector2(1, 0);
	elif bikeActualDir == "right_up":
		bikeDirection = Vector2(0.7, -0.3);
	elif bikeActualDir == "right_down":
		bikeDirection = Vector2(0.7, 0.3);
	#Left#
	elif bikeActualDir == "left":
		bikeDirection = Vector2(-1, 0);
	elif bikeActualDir == "left_up":
		bikeDirection = Vector2(-0.7, -0.3);
	elif bikeActualDir == "left_down":
		bikeDirection = Vector2(-0.7, 0.3);

	return bikeDirection;



#Function to set the rotation of the bike#
func setBikeRotation():
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

	if movingForward == true:
		if isAccelerating == true:
			#Down#
			if bikeActualDir == "down":
				$AnimatedSprite.animation = "bike_slow_pace_downward";
			elif bikeActualDir == "down_right":
				$AnimatedSprite.animation = "bike_slow_pace_downward_right";
			elif bikeActualDir == "down_left":
				$AnimatedSprite.animation = "bike_slow_pace_downward_left";
			#Up#
			elif bikeActualDir == "up":
				$AnimatedSprite.animation = "bike_slow_pace_upward";
			elif bikeActualDir == "up_right":
				$AnimatedSprite.animation = "bike_slow_pace_upward_right";
			elif bikeActualDir == "up_left":
				$AnimatedSprite.animation = "bike_slow_pace_upward_left";
			#Right#
			elif bikeActualDir == "right":
				$AnimatedSprite.animation = "bike_slow_pace_right";
			elif bikeActualDir == "right_up":
				$AnimatedSprite.animation = "bike_slow_pace_right_upward";
			elif bikeActualDir == "right_down":
				$AnimatedSprite.animation = "bike_slow_pace_right_downward";
			#Left#
			elif bikeActualDir == "left":
				$AnimatedSprite.animation = "bike_slow_pace_left";
			elif bikeActualDir == "left_up":
				$AnimatedSprite.animation = "bike_slow_pace_left_upward";
			elif bikeActualDir == "left_down":
				$AnimatedSprite.animation = "bike_slow_pace_left_downward";
		elif isAccelerating == false:
			#Down#
			if bikeActualDir == "down":
				$AnimatedSprite.animation = "bike_braking_downward";
			elif bikeActualDir == "down_right":
				$AnimatedSprite.animation = "bike_braking_downward_right";
			elif bikeActualDir == "down_left":
				$AnimatedSprite.animation = "bike_braking_downward_left";
			#Up#
			elif bikeActualDir == "up":
				$AnimatedSprite.animation = "bike_braking_upward";
			elif bikeActualDir == "up_right":
				$AnimatedSprite.animation = "bike_braking_upward_right";
			elif bikeActualDir == "up_left":
				$AnimatedSprite.animation = "bike_braking_upward_left";
			#Right#
			elif bikeActualDir == "right":
				$AnimatedSprite.animation = "bike_braking_right";
			elif bikeActualDir == "right_up":
				$AnimatedSprite.animation = "bike_braking_right_upward";
			elif bikeActualDir == "right_down":
				$AnimatedSprite.animation = "bike_braking_right_downward";
			#Left#
			elif bikeActualDir == "left":
				$AnimatedSprite.animation = "bike_braking_left";
			elif bikeActualDir == "left_up":
				$AnimatedSprite.animation = "bike_braking_left_upward";
			elif bikeActualDir == "left_down":
				$AnimatedSprite.animation = "bike_braking_left_downward";
		manageAnimationSpeedScale(bikeSpeed);
	if movingBackward == true:
		#Down#
		if bikeActualDir == "down":
			$AnimatedSprite.animation = "bike_backward_downward";
		elif bikeActualDir == "down_right":
			$AnimatedSprite.animation = "bike_backward_downward_right";
		elif bikeActualDir == "down_left":
			$AnimatedSprite.animation = "bike_backward_downward_left";
		#Up#
		elif bikeActualDir == "up":
			$AnimatedSprite.animation = "bike_backward_upward";
		elif bikeActualDir == "up_right":
			$AnimatedSprite.animation = "bike_backward_upward_right";
		elif bikeActualDir == "up_left":
			$AnimatedSprite.animation = "bike_backward_upward_left";
		#Right#
		elif bikeActualDir == "right":
			$AnimatedSprite.animation = "bike_backward_right";
		elif bikeActualDir == "right_up":
			$AnimatedSprite.animation = "bike_backward_right_upward";
		elif bikeActualDir == "right_down":
			$AnimatedSprite.animation = "bike_backward_right_downward";
		#Left#
		elif bikeActualDir == "left":
			$AnimatedSprite.animation = "bike_backward_left";
		elif bikeActualDir == "left_up":
			$AnimatedSprite.animation = "bike_backward_left_upward";
		elif bikeActualDir == "left_down":
			$AnimatedSprite.animation = "bike_backward_left_downward";



#Function to get the input of the player on bike#
func getInputOnLongboard():
	velocity = Vector2.ZERO;

	if Input.is_action_pressed("up"):
		isPushing = true;
		if longboardSpeed <= longboardMaxSpeed:
			longboardSpeed += longboardAcceleration;
		elif longboardSpeed > longboardMaxSpeed:
			longboardSpeed = longboardMaxSpeed;
	elif Input.is_action_pressed("down"):
		if longboardMovingForward == true:
			if longboardSpeed > 0:
				isBraking = true;
				longboardSpeed -= longboardBrake;
			elif longboardSpeed < 0:
				longboardSpeed = 0;
				isBraking = false;

	if Input.is_action_just_pressed("left"):
		$Timer.start();
		doubleTapRight = 0;
		doubleTapLeft +=1;
		if doubleTapLeft == 2:
			doubleTapLeft = 0;
			$Timer.stop();
			$Timer.wait_time = 0.5;
			if longboardActualDir.begins_with("right") == false:
				longboardVirtualRotation -= 90;
			elif longboardActualDir.begins_with("right") == true:
				longboardVirtualRotation = 0;
			setLongboardRotation();
	if Input.is_action_just_pressed("right"):
		$Timer.start();
		doubleTapLeft = 0;
		doubleTapRight +=1;
		if doubleTapRight == 2:
			doubleTapRight = 0;
			$Timer.stop();
			$Timer.wait_time = 0.5;
			longboardVirtualRotation += 90;
			setLongboardRotation();

	if longboardSpeed > 0:
		if Input.is_action_pressed("left"):
			if longboardActualDir == "downward":
				longboardVirtualRotation = 150;
			elif longboardActualDir == "upward":
				longboardVirtualRotation = 330;
			elif longboardActualDir == "right":
				longboardVirtualRotation = 60;
			elif longboardActualDir == "left":
				longboardVirtualRotation = 240;
			setLongboardRotation();
		elif Input.is_action_pressed("right"):
			if longboardActualDir == "downward":
				longboardVirtualRotation = 210;
			elif longboardActualDir == "upward":
				longboardVirtualRotation = 30;
			elif longboardActualDir == "right":
				longboardVirtualRotation = 120;
			elif longboardActualDir == "left":
				longboardVirtualRotation = 300;
			setLongboardRotation();
		longboardMovingForward = true;
		velocity = manageLongboardDirection();
		if isPushing == false:
			longboardSpeed -= longboardFriction;
		if longboardSpeed < 0:
			longboardSpeed = 0;
	elif longboardSpeed == 0:
		longboardMovingForward = false;
		isBraking = false;

	if Input.is_action_just_released("right"):
		if longboardActualDir.begins_with("downward"):
			longboardVirtualRotation = 180;
		elif longboardActualDir.begins_with("upward"):
			longboardVirtualRotation = 0;
		elif longboardActualDir.begins_with("right"):
			longboardVirtualRotation = 90;
		elif longboardActualDir.begins_with("left"):
			longboardVirtualRotation = 270;
		setLongboardRotation();
	if Input.is_action_just_released("left"):
		if longboardActualDir.begins_with("downward"):
			longboardVirtualRotation = 180;
		elif longboardActualDir.begins_with("upward"):
			longboardVirtualRotation = 0;
		elif longboardActualDir.begins_with("right"):
			longboardVirtualRotation = 90;
		elif longboardActualDir.begins_with("left"):
			longboardVirtualRotation = 270;
		setLongboardRotation();
	if Input.is_action_just_released("up"):
		isPushing = false;
	if Input.is_action_just_released("down"):
		isBraking = false;

	velocity = velocity.normalized() * longboardSpeed;



#Func to detect when the timer times out#
func _on_Timer_timeout():
	doubleTapLeft = 0;
	doubleTapRight = 0;



#Function to set the rotation of the bike#
func setLongboardRotation():
	if longboardVirtualRotation >= 360:
		longboardVirtualRotation = 0;
	if longboardVirtualRotation == -90:
		longboardVirtualRotation = 270;

	if longboardVirtualRotation == 0 or longboardVirtualRotation == 360:
		longboardActualDir = "upward";
	elif longboardVirtualRotation == 30:
		longboardActualDir = "upward_right";
	elif longboardVirtualRotation == 60:
		longboardActualDir = "right_upward";
	elif longboardVirtualRotation == 90:
		longboardActualDir = "right";
	elif longboardVirtualRotation == 120:
		longboardActualDir = "right_downward";
	elif longboardVirtualRotation == 150:
		longboardActualDir = "downward_right";
	elif longboardVirtualRotation == 180:
		longboardActualDir = "downward";
	elif longboardVirtualRotation == 210:
		longboardActualDir = "downward_left";
	elif longboardVirtualRotation == 240:
		longboardActualDir = "left_downward";
	elif longboardVirtualRotation == 270:
		longboardActualDir = "left";
	elif longboardVirtualRotation == 300:
		longboardActualDir = "left_upward";
	elif longboardVirtualRotation == 330:
		longboardActualDir = "upward_left";



#Function to handle the acceleration based on the direction on longboard#
func manageLongboardDirection() -> Vector2:
	var direction : Vector2 = Vector2.ZERO;

	#Up#
	if longboardActualDir == "upward":
		direction = Vector2(0, -1);
	elif longboardActualDir == "upward_right":
		direction = Vector2(0.3, -0.7);
	elif longboardActualDir == "upward_left":
		direction = Vector2(-0.3, -0.7);
	#Down#
	elif longboardActualDir == "downward":
		direction = Vector2(0, 1);
	elif longboardActualDir == "downward_right":
		direction = Vector2(0.3, 0.7);
	elif longboardActualDir == "downward_left":
		direction = Vector2(-0.3, 0.7);
	#Right#
	elif longboardActualDir == "right":
		direction = Vector2(1, 0);
	elif longboardActualDir == "right_upward":
		direction = Vector2(0.7, -0.3);
	elif longboardActualDir == "right_downward":
		direction = Vector2(0.7, 0.3);
	#Left#
	elif longboardActualDir == "left":
		direction = Vector2(-1, 0);
	elif longboardActualDir == "left_upward":
		direction = Vector2(-0.7, -0.3);
	elif longboardActualDir == "left_downward":
		direction = Vector2(-0.7, 0.3);

	return direction;



#Function to animate the Animated Sprite by testing what the player is doing on longboard#
func animateOnLongboard():
	if velocity == Vector2(0, 0):
		#Down#
		if longboardActualDir.begins_with("downward"):
			$AnimatedSprite.animation = "longboard_idle_downward";
		#Up#
		elif longboardActualDir.begins_with("upward"):
			$AnimatedSprite.animation = "longboard_idle_upward";
		#Right#
		elif longboardActualDir.begins_with("right"):
			$AnimatedSprite.animation = "longboard_idle_right";
		#Left#
		elif longboardActualDir.begins_with("left"):
			$AnimatedSprite.animation = "longboard_idle_left";

	elif longboardMovingForward:
		if isBraking == true:
			#Down#
			if longboardActualDir == "downward":
				$AnimatedSprite.animation = "longboard_braking_downward";
			elif longboardActualDir == "downward_right":
				$AnimatedSprite.animation = "longboard_braking_downward_right";
			elif longboardActualDir == "downward_left":
				$AnimatedSprite.animation = "longboard_braking_downward_left";
			#Up#
			elif longboardActualDir == "upward":
				$AnimatedSprite.animation = "longboard_braking_upward";
			elif longboardActualDir == "upward_right":
				$AnimatedSprite.animation = "longboard_braking_upward_right";
			elif longboardActualDir == "upward_left":
				$AnimatedSprite.animation = "longboard_braking_upward_left";
			#Right#
			elif longboardActualDir == "right":
				$AnimatedSprite.animation = "longboard_braking_right";
			elif longboardActualDir == "right_upward":
				$AnimatedSprite.animation = "longboard_braking_right_upward";
			elif longboardActualDir == "right_downward":
				$AnimatedSprite.animation = "longboard_braking_right_downward";
			#Left#
			elif longboardActualDir == "left":
				$AnimatedSprite.animation = "longboard_braking_left";
			elif longboardActualDir == "left_upward":
				$AnimatedSprite.animation = "longboard_braking_left_upward";
			elif longboardActualDir == "left_downward":
				$AnimatedSprite.animation = "longboard_braking_left_downward";
		elif isPushing == true:
			#Down#
			if longboardActualDir == "downward":
				$AnimatedSprite.animation = "longboard_moving_downward";
			elif longboardActualDir == "downward_right":
				$AnimatedSprite.animation = "longboard_moving_downward_right";
			elif longboardActualDir == "downward_left":
				$AnimatedSprite.animation = "longboard_moving_downward_left";
			#Up#
			elif longboardActualDir == "upward":
				$AnimatedSprite.animation = "longboard_moving_upward";
			elif longboardActualDir == "upward_right":
				$AnimatedSprite.animation = "longboard_moving_upward_right";
			elif longboardActualDir == "upward_left":
				$AnimatedSprite.animation = "longboard_moving_upward_left";
			#Right#
			elif longboardActualDir == "right":
				$AnimatedSprite.animation = "longboard_moving_right";
			elif longboardActualDir == "right_upward":
				$AnimatedSprite.animation = "longboard_moving_right_upward";
			elif longboardActualDir == "right_downward":
				$AnimatedSprite.animation = "longboard_moving_right_downward";
			#Left#
			elif longboardActualDir == "left":
				$AnimatedSprite.animation = "longboard_moving_left";
			elif longboardActualDir == "left_upward":
				$AnimatedSprite.animation = "longboard_moving_left_upward";
			elif longboardActualDir == "left_downward":
				$AnimatedSprite.animation = "longboard_moving_left_downward";
		elif isPushing == false and isBraking == false:
			#Down#
			if longboardActualDir == "downward":
				$AnimatedSprite.animation = "longboard_moving_downward";
			elif longboardActualDir == "downward_right":
				$AnimatedSprite.animation = "longboard_moving_downward_right";
			elif longboardActualDir == "downward_left":
				$AnimatedSprite.animation = "longboard_moving_downward_left";
			#Up#
			elif longboardActualDir == "upward":
				$AnimatedSprite.animation = "longboard_moving_upward";
			elif longboardActualDir == "upward_right":
				$AnimatedSprite.animation = "longboard_moving_upward_right";
			elif longboardActualDir == "upward_left":
				$AnimatedSprite.animation = "longboard_moving_upward_left";
			#Right#
			elif longboardActualDir == "right":
				$AnimatedSprite.animation = "longboard_moving_right";
			elif longboardActualDir == "right_upward":
				$AnimatedSprite.animation = "longboard_moving_right_upward";
			elif longboardActualDir == "right_downward":
				$AnimatedSprite.animation = "longboard_moving_right_downward";
			#Left#
			elif longboardActualDir == "left":
				$AnimatedSprite.animation = "longboard_moving_left";
			elif longboardActualDir == "left_upward":
				$AnimatedSprite.animation = "longboard_moving_left_upward";
			elif longboardActualDir == "left_downward":
				$AnimatedSprite.animation = "longboard_moving_left_downward";
		manageAnimationSpeedScale(longboardSpeed);



#Function to manage the speed of an animation#
func manageAnimationSpeedScale(var transportationSpeed : float):
	if transportationSpeed > 0 and transportationSpeed < 20:
		$AnimatedSprite.speed_scale = 0.4;
	elif transportationSpeed >= 20 and transportationSpeed < 40:
		$AnimatedSprite.speed_scale = 0.5;
	elif transportationSpeed >= 40 and transportationSpeed < 60:
		$AnimatedSprite.speed_scale = 0.6;
	elif transportationSpeed >= 60 and transportationSpeed < 70:
		$AnimatedSprite.speed_scale = 0.7;
	elif transportationSpeed >= 70 and transportationSpeed < 80:
		$AnimatedSprite.speed_scale = 0.8;
	elif transportationSpeed >= 80 and transportationSpeed < 90:
		$AnimatedSprite.speed_scale = 0.9;
	elif transportationSpeed >= 90 and transportationSpeed < 100:
		$AnimatedSprite.speed_scale = 1;
	elif transportationSpeed >= 100 and transportationSpeed < 110:
		$AnimatedSprite.speed_scale = 1.1;
	elif transportationSpeed >= 110 and transportationSpeed < 120:
		$AnimatedSprite.speed_scale = 1.2;
	elif transportationSpeed >= 120 and transportationSpeed < 130:
		$AnimatedSprite.speed_scale = 1.3;
	elif transportationSpeed >= 130 and transportationSpeed < 140:
		$AnimatedSprite.speed_scale = 1.4;
	elif transportationSpeed >= 140 and transportationSpeed < 150:
		$AnimatedSprite.speed_scale = 1.5;
	elif transportationSpeed >= 150 and transportationSpeed < 160:
		$AnimatedSprite.speed_scale = 1.6;
	elif transportationSpeed >= 160 and transportationSpeed < 170:
		$AnimatedSprite.speed_scale = 1.7;
	elif transportationSpeed >= 170 and transportationSpeed <= 180:
		$AnimatedSprite.speed_scale = 1.8;
