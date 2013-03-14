var canvas;
var context;

function SetupCanvas() {
	canvas = document.getElementById("game_canvas");
    context = canvas.getContext("2d");
    canvas.width = 800;
    canvas.height = 600;
    
};

function SnakeBlock(x, y) {
	this.x = x;
	this.y = y;
	this.width = 10;
	this.height = 10;		
};

SnakeBlock.prototype.Draw = function()
{	
	context.fillStyle = "#FF0000"; 
    context.fillRect(this.x,this.y,this.width,this.height);
    context.strokeStyle = "#FFFFFF";
    context.strokeRect(this.x,this.y,this.width,this.height);
        
};

function Snake()
{
	this.dir = 0;
	this.speed = 10;
	this.blocks = new Array();
	this.blocks.push(new SnakeBlock(10,10));
	this.blocks.push(new SnakeBlock(20,10));
	this.blocks.push(new SnakeBlock(30,10));
	this.blocks.push(new SnakeBlock(40,10));
	this.blocks.push(new SnakeBlock(50,10));
}

Snake.prototype.Draw = function()
{
	for(var i = 0; i < this.blocks.length; i++){
		this.blocks[i].Draw();
	}
	
};

Snake.prototype.Move = function()
{
	var first_block = this.blocks[0];
	var last_block = this.blocks[this.blocks.length - 1];
	var next_x = first_block.x;
	var next_y = first_block.y;
	switch(this.dir){
		case 0: //Right
			next_x += this.speed;
		break;
		case 1: //Left		
			next_x -= this.speed;
		break;			
		case 2: //Down
			next_y += this.speed;
		break;
		case 3: //Up
			next_y -= this.speed;
		break;
	};	
	if(next_x > canvas.width){
		next_x = 0;
	}else if(next_x < 0){
		next_x = canvas.width;
	}	
	if(next_y > canvas.height){
		next_y = 0;
	}else if(next_y < 0){
		next_y = canvas.height;
	}
	last_block.x = next_x;
	last_block.y = next_y;
	this.blocks.pop();
	this.blocks.unshift(last_block);
};

Snake.prototype.ChangeDirection = function(dir)
{
	if(this.dir == 0 && dir == 1){
		return;
	}
	if(this.dir == 1 && dir == 0){
		return;
	}
	if(this.dir == 2 && dir == 3){
		return;
	}
	if(this.dir == 3 && dir == 2){
		return;
	}
	this.dir = dir;	
}

function main() {	
    SetupCanvas();     
    snake = new Snake();
    setInterval(Update, 30);
};

function Update() {
	context.clearRect ( 0 , 0 , canvas.width , canvas.height );
	context.fillStyle = "#000000";
	context.fillRect(0,0, canvas.width, canvas.height);
	window.addEventListener('keydown',OnKeyDown,true);
	snake.Move();
	snake.Draw();
};

function OnKeyDown(evt) {
	switch(evt.keyCode){
		case 39:		
		snake.ChangeDirection(0);
		break;
		case 37:
		snake.ChangeDirection(1);
		break;
		case 40:
		snake.ChangeDirection(2);
		break;
		case 38:
		snake.ChangeDirection(3);
		break;
	}
}

main();


