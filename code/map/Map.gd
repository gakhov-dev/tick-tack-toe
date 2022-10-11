extends Node



export var d = 3


var app_canvas

onready var canvas = get_node("Node2D")


var CellClass = load("res://map/Cell.tscn");

signal player_turned

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

var map_size = 700


var map_data = {}
var cells = {}



func clear():
	for n in canvas.get_children():
		canvas.remove_child(n)
		n.queue_free()
	map_data.clear()
	cells.clear()	


func build_map(root_canvas):
	app_canvas = root_canvas
#	app_canvas.add_child(canvas)
	
	var cell
	var cell_size = 700 / d
	
	for j in d:
		for i in d:
			cell = create_cell(i,j, cell_size)
			add_cell(cell)
			map_data[Vector2(i,j)] = Global.CELL_STATUS.EMPTY 
			cells[Vector2(i,j)] = cell
			
var gap = 1			
func create_cell(i,j, size):
	var cell:Cell = CellClass.instance()
	cell.i = i
	cell.j = j
	cell.size = Vector2(size,size)/100
	cell.position = Vector2(i,j) * (size + gap) 
	cell.connect("clicked",self,"on_cell_clicked" )
	
	return cell
	
var _player_id = 0	
func activate_player(player_id):
	_player_id = player_id	

	
func on_cell_clicked(pos):
	if _player_id == 0: return
	
	var cell_status = map_data[pos]
	if (cell_status != 0): return
		
	set_cell(pos,_player_id)
	activate_player(0)
	emit_signal("player_turned")
		
	print("click "+str(pos))	
	

func add_cell(cell):
	canvas.add_child(cell)
	
	
func set_cell(place, status):
	map_data[place] = status
	var cell = cells.get(place)
	cell.set_status(status)
	

#1000  continue
#0 daw
#-1 win 0
#1 win X
func get_game_status_old(data):
	
	var dimention = d
	var count = 0
	var result = null
	
	#for horizont				
	for i in dimention:
		
		result = data[Vector2(i,0)]
		if result == Global.CELL_STATUS.EMPTY:
			result = null
			break
			
		for 	j in range(1, dimention):
			if (result != data[Vector2(i,j)]):
				result = null
				break
				
	if result != null: return result		
				
		
	#for vertical						
	for j in dimention:
		result = data[Vector2(0,j)]
		if result == Global.CELL_STATUS.EMPTY:
			result = null
			break

		for 	i in range(1, dimention):
			if (result != data[Vector2(i,j)]):
				result = null
				break
	if result!=null: return result		

	

	#for diagonal i == j	

	result = data[Vector2(0,0)]
	if result != Global.CELL_STATUS.EMPTY:
		for i in range(1,dimention):
			if (result!= data[Vector2(i,i)]):
				result = null
				break
		if result!=null: return result			
			
	#for diagonal i == d-j			
	result = data[Vector2(0,dimention - 1)]
	if result != Global.CELL_STATUS.EMPTY:
		for i in range(1,dimention):
			if (result != data[Vector2(i,dimention - i - 1)]):
				result = null
				break
		if result != null: return result					
				
	for value in data.values():	
		if (value == Global.CELL_STATUS.EMPTY):			
			return null
	
	return 0		
				
	


	
#winner[ -1: continue; 0: draw;  1: player1; 2: player2]
func get_game_status(data):
	
	var dimention = d
	var line = []
	
	var count = 0
	for result in [Global.CELL_STATUS.X, Global.CELL_STATUS.O]:
		#for vertical		
		for i in dimention:
			count = 0
			for 	j in dimention:
				if (result == data[Vector2(i,j)]):
					count +=1
					
			if count == dimention:
				return result
				
		
		#for horizont						
		for j in dimention:
			count = 0		
			for 	i in dimention:
				if (result == data[Vector2(i,j)]):
					count +=1
			if count == dimention:
				return result

		#for diagonal i == j	
		count = 0							
		for i in dimention:
			if (result == data[Vector2(i,i)]):
				count +=1
		if count == dimention:
			return result
		
		count = 0							
		for i in dimention:
			if (result == data[Vector2(i ,dimention - i -1)]):
				count +=1
		if count == dimention:
			return result
	

			
					
				
				
	count = 0			
	for i in dimention:
		for 	j in dimention:
			if (data[Vector2(i,j)] == Global.CELL_STATUS.EMPTY):			
				count +=1
				
	if count == 0:
		return 0

	
	return null		
				
				
		

	
	
	
		
	
				
			
			
		
	
	
