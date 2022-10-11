extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var dimention = 3

export(Global.PLAYER_TYPE) var player1_type = Global.PLAYER_TYPE.AI
export(Global.PLAYER_TYPE) var player2_type = Global.PLAYER_TYPE.AI
 

onready var canvas = get_node("Canvas")
onready var map = get_node("Map")
onready var player1 = get_node("Player1")
onready var player2 = get_node("Player2")

onready var menu = get_node("Menu")
onready var new_game_btn = menu.new_game_btn
onready var d3_btn = get_node("Menu/D3Btn")
onready var d4_btn = get_node("Menu/D4Btn")
onready var d5_btn = get_node("Menu/D5Btn")


onready var p1_ai_btn = get_node("Menu/P1AiBtn")
onready var p1_human_btn = get_node("Menu/P1HumanBtn")

onready var p2_ai_btn = get_node("Menu/P2AiBtn")
onready var p2_human_btn = get_node("Menu/P2HumanBtn")

onready var status_lbl =  get_node("Menu/Status")

onready var active_player = player1 


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game_btn.connect("pressed", self, "on_new_game")
	d3_btn.connect("pressed", self, "on_set_dimention", [3])
	d4_btn.connect("pressed", self, "on_set_dimention", [4])
	d5_btn.connect("pressed", self, "on_set_dimention", [5])
	
	p1_ai_btn.connect("pressed", self, "on_player1_change_type", [Global.PLAYER_TYPE.AI])
	p1_human_btn.connect("pressed", self, "on_player1_change_type", [Global.PLAYER_TYPE.HUMAN])
	
	p2_ai_btn.connect("pressed", self, "on_player2_change_type", [Global.PLAYER_TYPE.AI])
	p2_human_btn.connect("pressed", self, "on_player2_change_type", [Global.PLAYER_TYPE.HUMAN])
	


func on_set_dimention(n):
	dimention = n


func on_new_game():
	new_game_btn.disabled = true
	clear()
	new_game(dimention, player1_type, player2_type)

	
func on_player1_change_type(type):
	player1_type = type

	
func on_player2_change_type(type):
	player2_type = type



func new_game(dimention, type1, type2):
	map.d = dimention
	
	player1.type = type1
	player1.id = Global.CELL_STATUS.X
	player2.type = type2
	player2.id = Global.CELL_STATUS.O
	map.build_map(canvas)
	turn()
	#test_game_status()
	
	
func clear():
	map.clear()
	
	
func turn():
	active_player.connect("turn_completed", self, "_on_turn_completed")
	status_lbl.text = "Turn player:"+active_player.name
	
	active_player.turn()	
	
	
func _on_turn_completed():
	active_player.disconnect("turn_completed", self, "_on_turn_completed")
	if active_player == player1:
		active_player = player2
	else:
		active_player = player1	
	
	
	var result = map.get_game_status(map.map_data)
	
	print(" game status:"+ str(result) )
	if result == null:
		turn()
	else:
		#show game over status
		game_over(result)
		#print("map.map_data: "+str(map.map_data))
		#print(" Game Over winner is "+ str(result) )
		

func game_over(result):
	new_game_btn.disabled = false
	match result:
		0: status_lbl.text = "Draw"
		-1: status_lbl.text = "Player1 is win"
		1: status_lbl.text = "Player2 is win"



	
func get_game_status():
	var status = {"win":"none"} 
	
	
	var count = 0
	for result in [Global.CELL_STATUS.ONE, Global.CELL_STATUS.TOW]:
		#for horizont		
		
		for i in dimention:
			count = 0
			for 	j in dimention:
				if (result == map.map_data[Vector2(i,j)]):
					count +=1
			if count == dimention:
				status.win = Global.CELL_STATUS.keys()[result]
				return status
				
		
		#for vertical						
		for j in dimention:
			count = 0		
			for 	i in dimention:
				if (result == map.map_data[Vector2(i,j)]):
					count +=1
			if count == dimention:
				status.win = Global.CELL_STATUS.keys()[result]
				return status

		#for diagonal i == j	
		count = 0							
		for i in dimention:
			if (result == map.map_data[Vector2(i,i)]):
				count +=1
		if count == dimention:
			status.win = Global.CELL_STATUS.keys()[result]
			return status
		
		count = 0							
		for i in dimention:
			if (result == map.map_data[Vector2(i,dimention - i - 1)]):
				count +=1
		if count == dimention:
			status.win = Global.CELL_STATUS.keys()[result]
			return status
	

			
					
				
				
	count = 0			
	for i in dimention:
		for 	j in dimention:
			if (map.map_data[Vector2(i,j)] == Global.CELL_STATUS.EMPTY):			
				count +=1
				
	if count == 0:
		status.win = "draw"
		return status

	
	return status		
				
				
				
				
				
					
					
func test_game_status():
	#var data1 =  {Vector2(0, 0):-1}
	var data1 =  {Vector2(0, 0):-1, Vector2(0, 1):1, Vector2(0, 2):-1, Vector2(1, 0):-1, Vector2(1, 1):-1, Vector2(1, 2):1, Vector2(2, 0):1, Vector2(2, 1):1, Vector2(2, 2):-1}

	#map.get_game_status(data1)
	for p in data1:
		map.set_cell(p,data1[p])		




