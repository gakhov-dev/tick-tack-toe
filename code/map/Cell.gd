extends Node2D
class_name Cell

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var i = 0
export var j = 0

onready var bg = get_node("Bg");
onready var player1 = get_node("Player1Mark");
onready var player2 = get_node("Player2Mark");

# 0 1 2
#export(Global.CELL_STATUS) var s:int = 0

export(Vector2) var size


onready var debug_lbl = get_node("Label")
onready var clicker = get_node("Area2D")
var coord

signal clicked(pos)

func _ready():
	pass # Replace with function body.
	set_size(size)
	set_status(Global.CELL_STATUS.EMPTY)
	
	clicker.connect("clicked", self, "on_clicked" )
	


var active_player_id = 0	

func on_clicked():
	emit_signal("clicked",Vector2(i,j))
	
	



	
	
		


func set_size(value:Vector2):
	bg.scale = value
	player1.scale = value
	player2.scale = value
	coord = str(i) + "," + str(j)
	clicker.scale = value
	clicker.position = 50 * clicker.scale
	


func set_status(value):
	match value:
		Global.CELL_STATUS.EMPTY: 
			player1.visible = false;
			player2.visible = false;
		Global.CELL_STATUS.X: 	
			player1.visible = true;
			player2.visible = false;

		Global.CELL_STATUS.O: 	
			player1.visible = false;
			player2.visible = true;
			
	debug(str(value))		
			
func debug(txt):
	debug_lbl.text = coord+": "+txt			
	


	
			
			
			
			
	
	
		
			
			
			

