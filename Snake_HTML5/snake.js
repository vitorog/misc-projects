var canvas;
var context;

function SetupCanvas() {
	canvas = document.getElementById("game_canvas");
    context = canvas.getContext("2d");
    canvas.width = 800;
    canvas.height = 600;
    window.addEventListener('keydown',OnKeyDown,true);
    
};

function SnakeBlock(x, y) {
	this.x = x;
	this.y = y;
	this.width = 15;
	this.height = 15;		
};

SnakeBlock.prototype.Draw = function()
{	
	context.fillStyle = "#FFFFFF"; 
    context.fillRect(this.x,this.y,this.width,this.height);
    context.strokeStyle = "#BBBBBB";
    context.strokeRect(this.x,this.y,this.width,this.height);
        
};

function Snake()
{
	this.dir = 0;	
	this.move_rate = 100; //Move rate in ms
	this.refresh_counter = 0; //The snake only moves if refresh_counter is higher than the move rate
	this.blocks = new Array();	
	this.AddBlock();
	this.AddBlock();
	this.AddBlock();
	this.AddBlock();
	this.AddBlock();	
}

Snake.prototype.AddBlock = function()
{
	if(this.blocks.length > 0){
		var last_block = this.blocks[this.blocks.length - 1];
		var next_x = last_block.x;
		var next_y = last_block.y;
		switch(this.dir){
		case 0: //Right
			next_x -= last_block.width;
		break;
		case 1: //Left		
			next_x += last_block.width;
		break;			
		case 2: //Down
			next_y -= last_block.height;
		break;
		case 3: //Up
			next_y += last_block.height;
		break;
		};	
		this.blocks.push(new SnakeBlock(next_x, next_y));	
	}else{
		this.blocks.push(new SnakeBlock(canvas.width/2, canvas.height/2));
	}
	
}

Snake.prototype.Draw = function()
{
	for(var i = 0; i < this.blocks.length; i++){
		this.blocks[i].Draw();
	}
	
};

Snake.prototype.Move = function()
{
	this.refresh_counter++;
	if(this.refresh_counter < this.move_rate){
		return;
	}else{
		this.refresh_counter = 0;
	}	
	var first_block = this.blocks[0];
	var last_block = this.blocks[this.blocks.length - 1];
	var next_x = first_block.x;
	var next_y = first_block.y;
	switch(this.dir){
		case 0: //Right
			next_x += first_block.width;
		break;
		case 1: //Left		
			next_x -= first_block.width;
		break;			
		case 2: //Down
			next_y += first_block.height;
		break;
		case 3: //Up
			next_y -= first_block.height;
		break;
	};	
	if(next_x > canvas.width){
		next_x = 0;
	}else if(next_x < 0){
		next_x = canvas.width - first_block.width;
	}	
	if(next_y > canvas.height){
		next_y = 0;
	}else if(next_y < 0){
		next_y = canvas.height - first_block.height;
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
    setInterval(Update, 0);    
};

function Update() {
	context.clearRect ( 0 , 0 , canvas.width , canvas.height );
	context.fillStyle = "#000000";
	context.fillRect(0,0, canvas.width, canvas.height);	
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


