extends Node



export(Global.PLAYER_TYPE) var type = Global.PLAYER_TYPE.HUMAN

export(NodePath) var map_path:NodePath;
onready var map:Map = get_node(map_path)

export(Color) var color:Color;
export(Global.CELL_STATUS) var id =  Global.CELL_STATUS.O

var turn_delay: = 0.5;

signal turn_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print ("player: "+ name +" id "+ str(id) +"  type:"+str(type) )
	

func turn():
	print ("player: "+ name +" id "+ str(id) +"  type:"+str(type) )
	var place
	if type == Global.PLAYER_TYPE.AI:
		yield(get_tree().create_timer(0.2), "timeout")
		print("turn player id: "+str(id))
		#var place = choose_rnd_cell(map.map_data)
		#place = choose_best_move(map.map_data, id, 0)
		place = choose_move_by_weight(map.map_data, id)
		print ("best pos: " + str(place))
		map.show_weight(map.map_data)
		
		
		if (place!=null):
			map.set_cell(place, id)
		yield(get_tree().create_timer(turn_delay), "timeout")
		emit_signal("turn_completed")

		
	if type == Global.PLAYER_TYPE.HUMAN:
		map.connect("player_turned", self, "on_player_turned")
		map.activate_player(id)
		
		
	#if type == Global.PLAYER_TYPE.RND:
		#place = choose_rnd_cell(map.map_data)
		

		
func on_player_turned():
	map.disconnect("player_turned", self, "on_player_turned")
	emit_signal("turn_completed")			

	
func choose_rnd_cell(map_data):
	var places:Array = get_rnd_empty_cells(map_data)
	if places.size() >0:
		return places[0]
	return null	
	
	
func get_rnd_empty_cells(map_data):	
	
	var cell_status
	var places = []
	for place in map_data:
		cell_status = map_data.get(place)
		if cell_status == Global.CELL_STATUS.EMPTY:
			places.append(place)
				
	randomize()
	places.shuffle()
	return places
	

#TODO
##coose win	


func choose_move_by_weight(map_data, player_id):
	map.calc_line_status()
	map.calc_weights(map_data, player_id)
	
	var max_weight = -1000
	var res_cell
	for cell in map.weights:
		if map.weights[cell] > max_weight:
			res_cell = cell
			max_weight = map.weights[cell]
			
	return res_cell
	
	
	
	
	
		
		
#player id 		
func choose_best_move(map_data, player_id, depth):
	
	var best_score = -1 * player_id
	var score = null
	#var is_max = (player_id == Global.CELL_STATUS.X)
	var move_place
	
	
	for place in map_data:
		if map_data[place] == Global.CELL_STATUS.EMPTY:
			
			map_data[place] = player_id
			score = minmax(map_data, -1*player_id, 0)
			map_data[place] = Global.CELL_STATUS.EMPTY
			
			if player_id==1:
				if best_score < score:
					move_place = Vector2(place.x, place.y)
					best_score = score
			if player_id==-1:
				if best_score > score:
					move_place = Vector2(place.x, place.y)
					best_score = score
					
					
					

	return move_place		


func get_best_score(player_id, best_score, score):
	
	if best_score == score: return best_score
	
	if best_score == null:
		return score
	if score == null:
		return best_score
	
		
	
	if player_id == Global.CELL_STATUS.X:
		max(best_score, score)				
	if player_id == Global.CELL_STATUS.O:
		min(best_score,score)				
					
					


func minmax(map_data, player_id, depth):				
	
	var result = map.get_game_status(map_data)		
	
	if result != null:
		return result
	

	var best_result = -1 * player_id
	
	if (player_id == 1):
		for place in map_data:		
			if map_data[place] == Global.CELL_STATUS.EMPTY:
				map_data[place] = player_id
				result = minmax(map_data, -1*player_id, depth + 1)
				map_data[place] = Global.CELL_STATUS.EMPTY
				best_result = max(best_result, result)
	else:
		for place in map_data:		
			if map_data[place] == Global.CELL_STATUS.EMPTY:
				map_data[place] = player_id
				result = minmax(map_data, -1*player_id, depth + 1)
				map_data[place] = Global.CELL_STATUS.EMPTY
				best_result = min(best_result, result)
		
	
	
	

	return best_result		
