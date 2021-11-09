extends AnimatedSprite

func _physics_process(delta):
	if $Bike_button.is_hovered() == true:
		$".".animation = "transportation_menu_hover_bike";
	elif $Foot_button.is_hovered() == true:
		$".".animation = "transportation_menu_hover_foot";
	elif $Longboard_button.is_hovered() == true:
		$".".animation = "transportation_menu_hover_longboard";



func _on_Bike_button_pressed():
	get_parent().switchTransportation("bike");

func _on_Foot_button_pressed():
	get_parent().switchTransportation("walk");

func _on_Longboard_button_pressed():
	get_parent().switchTransportation("longboard");
