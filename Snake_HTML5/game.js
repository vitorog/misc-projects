var canvas;
var context;
var game_over = false;

var BLOCKS_WIDTH = 32;
var BLOCKS_HEIGHT = 32;
var BLOCKS_COUNT = 25;

function Food(x, y)
{
	this.x = x;
	this.y = y;
	this.width = canvas.width/BLOCKS_COUNT;
	this.height = canvas.height/BLOCKS_COUNT;
	this.eaten = true;
}

Food.prototype.Draw = function()
{
	context.fillStyle = "#0000FF";
	context.fillRect(this.x,this.y, this.width, this.height);	
	context.strokeStyle = "#BBBBBB";
    context.strokeRect(this.x,this.y,this.width,this.height);        
}

function SetupGame() {
	canvas = document.getElementById("game_canvas");
    context = canvas.getContext("2d");
    canvas.width = 800;
    canvas.height = 800;
    window.addEventListener('keydown',HandleRestart,true);   
};

function Update() {
	context.clearRect ( 0 , 0 , canvas.width , canvas.height );
	context.fillStyle = "#000000";
	context.fillRect(0,0, canvas.width, canvas.height);	
	if(snake.CheckSelfCollision()){
		game_over = true;			
	}
	if(!game_over){
		snake.Move();	
	}	
	if(food.eaten){
		GenerateFood();
	}
	if(snake.CheckFoodCollision(food.x,food.y)){
		food.eaten = true;
		snake.AddTailBlock();
	}
	snake.Draw();	
	food.Draw();
	DrawGrid();
};

function DrawGrid()
{
	var grid_x_size = canvas.width/BLOCKS_COUNT;
	var grid_y_size = canvas.height/BLOCKS_COUNT;
	for(var i = 0; i < BLOCKS_COUNT;i++){
		for(var j = 0; j < BLOCKS_COUNT; j++){
			context.strokeStyle = "#FF0000";
			context.strokeRect(i*grid_x_size,j*grid_y_size, grid_x_size, grid_y_size);	
		}
	}	
}

function HandleRestart(evt)
{
	switch(evt.keyCode){
		case 32:	
			if(game_over){	
				Restart()
			}
		break;
	}
}

function Restart()
{
	delete snake;
	snake = new Snake();
	game_over = false;
	GenerateFood();
}

function GenerateFood()
{
	var size_tile_x = canvas.width/BLOCKS_COUNT;
	var size_tile_y = canvas.height/BLOCKS_COUNT;
	food.x = 0;
	food.y = 0;
	do{
		food.x += Math.floor((BLOCKS_COUNT * Math.random())) * size_tile_x;
		food.y += Math.floor((BLOCKS_COUNT * Math.random())) * size_tile_y;
	}while(snake.CheckFoodCollision(food.x,food.y));
	food.eaten = false;
}

function main() {	
    SetupGame();     
    snake = new Snake();
    food = new Food(0,0);   
    setInterval(Update, 0);    
};


main();