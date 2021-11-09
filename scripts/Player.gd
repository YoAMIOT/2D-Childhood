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
var virtualRotation : int = 180;
var bikeActualDir : String = "down";
var movingBackward : bool = false;
var bikeAcceleration: float = 0.5;
var bikeBrake : float = 1.2;
var bikeMaxSpeed : int = 120;
var movingForward : bool = false;
var isAccelerating: bool = false;
var bikeFriction : float = 0.4;



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
	elif lastTransport == "bike" and transport == "walk":
		if bikeActualDir.begins_with("up"):
			footActualDir = "up";
		elif bikeActualDir.begins_with("down"):
			footActualDir = "down";
		elif bikeActualDir.begins_with("right"):
			footActualDir = "right";
		elif bikeActualDir.begins_with("left"):
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
		setRotation();
	if Input.is_action_just_pressed("left"):
		virtualRotation -= 30;
		setRotation();

	if Input.is_action_pressed("up"):
		isAccelerating = true;
		if bikeSpeed <= bikeMaxSpeed:
			bikeSpeed += bikeAcceleration;
		elif bikeSpeed > bikeMaxSpeed:
			bikeSpeed = bikeMaxSpeed;
	if Input.is_action_just_released("up"):
		isAccelerating = false;

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

	if Input.is_action_pressed("down"):
		if movingForward == true:
			if bikeSpeed > 0:
				bikeSpeed -= bikeBrake;
			elif bikeSpeed < 0:
				bikeSpeed = 0;
		if movingForward == false:
			velocity = manageBikeDirection() * -1;
			movingBackward = true;
	if Input.is_action_just_released("down") and bikeSpeed == 0:
		movingBackward = false;

	if movingForward:
		velocity = velocity.normalized() * bikeSpeed;
	if movingBackward == true:
		velocity = velocity.normalized() * 15;



#Function to handle the acceleration based on the direction#
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
func setRotation():
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
		manageAnimationSpeedScale();
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



#Function to manage the speed of an animation#
func manageAnimationSpeedScale():
	var currentAnim = $AnimatedSprite.animation;
	if bikeSpeed > 0 and bikeSpeed < 20:
		$AnimatedSprite.speed_scale = 0.4;
	elif bikeSpeed >= 20 and bikeSpeed < 40:
		$AnimatedSprite.speed_scale = 0.5;
	elif bikeSpeed >= 40 and bikeSpeed < 60:
		$AnimatedSprite.speed_scale = 0.6;
	elif bikeSpeed >= 60 and bikeSpeed < 70:
		$AnimatedSprite.speed_scale = 0.7;
	elif bikeSpeed >= 70 and bikeSpeed < 80:
		$AnimatedSprite.speed_scale = 0.8;
	elif bikeSpeed >= 80 and bikeSpeed < 90:
		$AnimatedSprite.speed_scale = 0.9;
	elif bikeSpeed >= 90 and bikeSpeed < 100:
		$AnimatedSprite.speed_scale = 1;
	elif bikeSpeed >= 100 and bikeSpeed < 110:
		$AnimatedSprite.speed_scale = 1.1;
	elif bikeSpeed >= 110 and bikeSpeed < 120:
		$AnimatedSprite.speed_scale = 1.2;
	elif bikeSpeed >= 120 and bikeSpeed < 130:
		$AnimatedSprite.speed_scale = 1.3;
	elif bikeSpeed >= 130 and bikeSpeed < 140:
		$AnimatedSprite.speed_scale = 1.4;
	elif bikeSpeed >= 140 and bikeSpeed <= 150:
		$AnimatedSprite.speed_scale = 1.5;
