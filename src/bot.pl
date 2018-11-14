
/**
			===================================
			========= Bot Play Levels =========
			===================================
 **/
botPlay(Tab, Player, OutTab):-
	valid_moves(Tab, Player, MovesList),
	length(MovesList, L), 
	random(0, L, Index), 
	nth0(Index, MovesList, Move), 
	Move = [Row, Col, Dir], 
	Piece is Player + 1, 
	movePiece(Row, Col, Dir, Piece, Tab, OutTab).

botPlayGreedy(Tab, Player, OutTab):-
	move_and_evaluate(Tab, Player, MovesList),
	nth0(0, MovesList, Move), 
	Move = [_, Row, Col, Dir], 
	Piece is Player + 1, 
	movePiece(Row, Col, Dir, Piece, Tab, OutTab).

/*
			===================================
*/




/**
			===================================
			===== Bot Heuristic Functions =====
			===================================
 **/


evaluateBoard(Tab, Player, Value, Length):-
	(
		checkVictory(Tab, Player, Length),	Value = 100;
		findall(B, ( checkTwoConnected(Tab, Player, Length), B = 10 ), Score),
		sumlist(Score, Value)
	).


checkTwoConnected(Tab, Player, Length):-
	K is Length - 1,
	(
		checkTwoColumns(Tab, Player, K);
		checkTwoRows(Tab, Player, K);
		checkTwoBiggerDiagonals(Tab, Length)
	).

isTwoConnected(Player, List):-
	Piece is Player + 1, 
	sublist([Piece, Piece], List).

checkTwoColumns(Tab, Player, N):-
	between(0, N, N1), 
	getColumnN(Tab, N1, Col), 
	isTwoConnected(Player, Col).

checkTwoRows(Tab, Player, N):-
	between(0, N, N1), 
	nth0(N1, Tab, Row), 
	isTwoConnected(Player, Row).

checkTwoBiggerDiagonals(Tab, Length):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Tab, Diagonal, Offset), 
    isTwoConnected(0, Diagonal). 
    
/*
			===================================
*/

