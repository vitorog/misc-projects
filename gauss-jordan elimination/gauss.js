var expanded_matrix = new Array();
var x_values = new Array();

/*var expanded_matrix = [
[3, 2, 0, 1, 3],
[9, 8, -3, 4, 6],
[-6, 4, -8, 0, -16],
[3, -8, 3, -4, 18]
];

var x_values = [[0,0,0,0]];*/

function read_input()
{
	var input = document.getElementById("input").value;
	var rows = input.split("\n");
	var swap_lines = false;
	x_values.push(new Array());
	for(var i = 0; i < rows.length; i++){
		expanded_matrix.push(new Array());		
		var columns = rows[i].split(" ");
		if(columns.length != (rows.length + 1)){
			print_message("Not a quadratic matrix.");
			return false;
		}				
		for(var j = 0; j < columns.length; j++){			
			expanded_matrix[i].push(parseInt(columns[j]));		
		}
		x_values[0].push(0);
	}	
	for(var i = 0; i < expanded_matrix.length; i++){		
		if(expanded_matrix[i][i]===0){
			for(var k = 0; k < expanded_matrix.length; k++){
				if(k===i){
					continue;
				}
				if(expanded_matrix[k][k] != 0){
					var i_row = expanded_matrix[i];
					var k_row = expanded_matrix[k];
					expanded_matrix[i] = k_row;
					expanded_matrix[k] = i_row;
				}
			}
		}		
	}
	return true;	
}

function clear()
{
	expanded_matrix = new Array();
	x_values = new Array();
	var result_div = document.getElementById("result");
	result_div.innerHTML = "";
}

function print_message(message)
{
	var result_div = document.getElementById("result");
	result_div.innerHTML = message;
}

function print_matrix(matrix, header)
{
	var num_rows = matrix.length;
	var num_columns = matrix[0].length;
	var output = "<table cellpadding='20px' border='1'>";
	for(var i = 0; i < num_rows; i++){
		output += "<tr>";
		for(var j = 0; j < num_columns; j++){
			output += "<td>" + matrix[i][j] + "</td>";
		}
		output += "</tr>";
	}
	output += "</table>";
	var result_div = document.getElementById("result");
	result_div.innerHTML += header;
	result_div.innerHTML += output;	
	result_div.innerHTML += "<br>";
}

function triangularize(matrix)
{
	var num_rows = matrix.length;
	var num_columns = matrix[0].length;
	for(var i = 0; i < num_rows - 1; i++){ //Pivot row
		for(var j = i + 1; j < num_rows; j++){
			//The elements on the pivot row will be multiplied by this factor
			//and they will be added later in a way that the elements on the pivot's column will be zeroed
			var factor = -(matrix[j][i] / matrix[i][i]); 
			for(var k = i; k < num_columns; k++){				
				//matrix[i][k] is the pivot's line element. We multiply it by the factor (which is negative)
				//and add it to the current element
				matrix[j][k] = (matrix[i][k] * factor) + matrix[j][k]; 
			}
		}
	}
}

function solve(matrix)
{
	var num_rows = matrix.length;
	var num_columns = matrix[0].length;
	for(var i = (num_rows - 1); i >= 0; i--)
	{
		var row_sum = 0;
		rows_sum = matrix[i][num_columns-1]; //the last column is the equation's results column-matrix
		for(var j = (num_columns - 2); j >= 0; j--){
			if(j === i){ //If the current element is the one we want to calculate we can stop and go to the next line
				x_values[0][i] = (rows_sum / matrix[i][j]);				
				break;
			}
			//This sums the value of the already known variables multiplied by the coeficients
			rows_sum -= (matrix[i][j] * x_values[0][j]); 
		}
	}
}


function OnSolveClicked()
{
	clear();
	if(read_input()){
		print_matrix(expanded_matrix, "Input matrix: ");
		triangularize(expanded_matrix);
		print_matrix(expanded_matrix, "Triangular matrix: ");
		solve(expanded_matrix);
		print_matrix(x_values, "X values: ");
	}
}
