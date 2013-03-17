var canvas;
var context;
var game_over = false;

var BLOCKS_WIDTH = 21;
var BLOCKS_HEIGHT = 21;
var BLOCKS_COUNT_X = 20;
var BLOCKS_COUNT_Y = 11;
var PLAY_AREA_X = 10;
var PLAY_AREA_Y = 35;
var PLAY_AREA_WIDTH = BLOCKS_COUNT_X * BLOCKS_WIDTH;
var PLAY_AREA_HEIGHT = BLOCKS_COUNT_Y * BLOCKS_HEIGHT;
var TEXT_AREA_X = 10;
var TEXT_AREA_Y = PLAY_AREA_Y - 10;
var SCORE = 0;


function Food(x, y)
{
	this.x = x;
	this.y = y;
	this.width = BLOCKS_WIDTH;
	this.height = BLOCKS_WIDTH;
	this.eaten = true;
}

Food.prototype.Draw = function()
{
	context.fillStyle = "#999999";
	context.fillRect(this.x,this.y, this.width, this.height);	
	// context.strokeStyle = "#BBBBBB";
    // context.strokeRect(this.x,this.y,this.width,this.height);        
}

function SetupGame() {
	canvas = document.getElementById("game_canvas");
    context = canvas.getContext("2d");
    canvas.width = PLAY_AREA_WIDTH + 20;
    canvas.height = 280;
    window.addEventListener('keydown',HandleRestart,true);   
};

function Update() {	
	ClearScreen();
	Logic();
	Draw();	
};

function ClearScreen()
{
	context.clearRect (0 , 0, canvas.width , canvas.height );
	context.fillStyle = "#bcdc94";
	context.fillRect(0,0, canvas.width, canvas.height);	
}


function Logic()
{
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
		SCORE += 10;
	}
}

function Draw()
{		
	snake.Draw();	
	food.Draw();
	DrawBorder();	
	DrawScores();
}

function DrawScores()
{
	context.fillStyle = "#000000";
	context.font = "20px Calibri";
	context.fillText("Score: " + SCORE, TEXT_AREA_X,TEXT_AREA_Y);
}

function DrawBorder()
{
	context.strokeStyle = "#000000";
	context.strokeRect(PLAY_AREA_X,PLAY_AREA_Y,PLAY_AREA_WIDTH,PLAY_AREA_HEIGHT);
}


function DrawGrid()
{
	var grid_x_size = BLOCKS_WIDTH;
	var grid_y_size = BLOCKS_HEIGHT;
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
	SCORE = 0;
	GenerateFood();
}

function GenerateFood()
{
	
	do{
		food.x = PLAY_AREA_X + Math.floor((BLOCKS_COUNT_X * Math.random())) * BLOCKS_WIDTH;
		food.y = PLAY_AREA_Y + Math.floor((BLOCKS_COUNT_Y * Math.random())) * BLOCKS_HEIGHT;
	}while(snake.CheckFullCollision(food.x,food.y));
	food.eaten = false;
}

function main() {	
    SetupGame();     
    snake = new Snake();
    food = new Food(PLAY_AREA_X, PLAY_AREA_Y);   
    setInterval(Update, 0);    
};

main();