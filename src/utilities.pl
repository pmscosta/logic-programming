
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
	X is Temp - 97, 
    get_code(_).

/**
askUserInput(-X, -Y, +N).
Asks for User Input coordinates. 
Translates visual coordinates into the internal ones used in the list.
@param X - the x coordinate (visually a number)
@param Y - the y coordinate (visually a letter)
@param N - the board length
**/
askUserInput(X, Y, N):-
    write(' Insert the piece coordinates: '),
	getCoordFromInt(Temp),
	X is N - Temp,
	getCoordFromAscii(Y),
    get_code(_).


invalidMove:-
    write('Invalid Coordinates!'), nl.

validCoordinates:- write('VALID'),nl.