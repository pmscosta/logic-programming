
/**
getCoordFromInt(-X).
Reads a numerical coordinate from the user input.
@param X - the output numerical coordinate
**/
getCoordFromInt(X):-
	get_code(Temp),
	X is Temp - 48.


/**
getCoordFromAscii(-X).
Read and converts an alphabetic coordinate from the user input to a numerical coordinate. 
A = 1, B = 2, and so on.
@param X - the output numerical coordinate
**/
getCoordFromAscii(X):-
	get_code(Temp),
	X is Temp - 97.

/**
askUserInput(-X, -Y, +N).
Asks for User Input coordinates. 
Translates visual coordinates into the internal ones used in the list.
@param Row - the row
@param Col - the column
@param N - the board length
**/
askUserInput(Row, Col, N):-
    write(' Insert the piece coordinates: '),
	getCoordFromInt(Temp),
	Row is N - Temp,
	getCoordFromAscii(Col), 
	get_code(_).


askUserMove(X):-
	write(' Insert the move direction: '), 
	read(X),
	get_code(_).


waitForKeyPress:-
	get_code(_).
