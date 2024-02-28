extends KinematicBody2D
#Variables in Caps is a Constant (const) & variables in lowercase is a Normal Variable (var)
#Movement Variables (p = player)
const P_ACCEL = 300
const P_FRICTION = 100
var p_max_speed = 650
var p_velocity = Vector2.ZERO

#Oxygen
var oxygen_level = 1000
const oxygen_idle_decrease = 12
const oxygen_dash_decrease = 2

func _physics_process(delta):
	if Input.is_action_just_pressed("end"): #End game 
		end_game()
	
	if oxygen_level < 0: #Close game if out of oxygen
		end_game()
		
	var p_input = Input.get_vector("left","right","up","down") #Get movement angle
	player_movement(p_input, delta) 
	player_dash()
	move_and_slide(p_velocity) #Apply Movement

func player_movement(p_input, delta): #Convert movement angle to actual movement
	if p_input: p_velocity = p_velocity.move_toward(p_input * p_max_speed , delta * P_ACCEL) #If moving
	else: p_velocity = p_velocity.move_toward(Vector2(0,0), delta * P_FRICTION) #If not

func player_dash():
	if Input.is_action_pressed("dash") && (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down")): #If dashing & moving
		p_max_speed = 350 #Change top speed
		oxygen_level -= oxygen_dash_decrease #Adjust oxygen
		$Player_UI_Layer/Oxygen_Bar.value -= 2
	else:
		p_max_speed = 150

func _on_Oxygen_Timer_timeout(): #Oxygen Countdown
	oxygen_level -= oxygen_idle_decrease
	$Player_UI_Layer/Oxygen_Bar.value -= oxygen_idle_decrease #Update oxygen visual
	
func end_game(): #Quit Game
	get_tree().quit()

