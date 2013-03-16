function SnakeBlock(x, y) {
	
	this.width = canvas.width/BLOCKS_COUNT;
	this.height = canvas.width/BLOCKS_COUNT;	
	this.x = x;
	this.y = y;
	this.draw_style = "#FFFFFF";	
};

SnakeBlock.prototype.Draw = function()
{	
	context.fillStyle = this.draw_style;
    context.fillRect(this.x,this.y,this.width,this.height);
    context.strokeStyle = "#BBBBBB";
    context.strokeRect(this.x,this.y,this.width,this.height);        
};

SnakeBlock.prototype.Collides = function(block)
{
	if(this.x === block.x && this.y === block.y){
		this.draw_style = "#FF0000";
		block.draw_style = "#FF0000";
		return true;
	}
	return false;
}


function Snake()
{
	this.dir = 0;	
	this.move_rate = 10; //Move rate in ms
	this.refresh_counter = 0; //The snake only moves if refresh_counter is higher than the move rate
	this.block_change_dir = false; //This variable blocks a change of direction until the snake has moved once after a change
	this.blocks = new Array();	
	for(var i = 0; i < 5; i++){
		this.AddBlock();
	}
	
	window.addEventListener('keydown',this.HandleInput,true);    
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
		var block_size_x = canvas.width/BLOCKS_COUNT;
		var block_size_y = canvas.height/BLOCKS_COUNT;
		var x = Math.floor(BLOCKS_COUNT/2) * block_size_x;
		var y = Math.floor(BLOCKS_COUNT/2) * block_size_y;
		this.blocks.push(new SnakeBlock(x,y));
	}	
}

Snake.prototype.AddTailBlock = function()
{
	//This code section finds out the direction of the tail (it can be different from the head's)
	//and add the last block accordingly
	var last_block = this.blocks[this.blocks.length - 1];
	var aux_block = this.blocks[this.blocks.length - 2];
	var tail_dir; 
	if(last_block.x < aux_block.x){
		tail_dir = 0;		
	}else if(last_block.x > aux_block.x){
		tail_dir = 1;
	}else if(last_block.y < aux_block.y){
		tail_dir = 2;
	}else{
		tail_dir = 3;
	}
	var next_x = last_block.x;
	var next_y = last_block.y;
	switch(tail_dir){
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
	if(next_x >= canvas.width){
		next_x = 0;
	}else if(next_x < 0){
		next_x = canvas.width - first_block.width;
	}	
	if(next_y >= canvas.height){
		next_y = 0;
	}else if(next_y < 0){
		next_y = canvas.height - first_block.height;
	}
	last_block.x = next_x;
	last_block.y = next_y;	
	this.blocks.pop();
	this.blocks.unshift(last_block);
	block_change_dir = false;
};

Snake.prototype.ChangeDirection = function(dir)
{
	if(!block_change_dir){
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
		block_change_dir = true;
	}	
}

Snake.prototype.CheckSelfCollision = function()
{
	for(var i = 1; i < this.blocks.length; i++){		
		if(this.blocks[0].Collides(this.blocks[i])){
			return true;
		}			
	}	
	return false;
}

Snake.prototype.CheckFoodCollision = function(x,y)
{
	if(this.blocks[0].x === x && this.blocks[0].y === y){
		return true;
	}
	return false;
}


Snake.prototype.HandleInput = function(evt) {
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




