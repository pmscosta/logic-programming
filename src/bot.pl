
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

evaluateMove(Tab, Player, Move, Value, Length):-
	Move = [Row, Col, Move],
	Piece is Player + 1,
	movePiece(Row, Col, Move, Piece, Tab, OutTab),
	evaluateBoard(OutTab, Player, Value, Length).


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


/**
			===================================
			======== Minimax ALgorithm ========
			===================================
 **/

minimax(Tab, Player, Pos, BestNextPos, Val) :-
	length(Tab, Length),
	valid_moves(Tab, Player, MovesList),
	best(Tab, Player, MovesList, BestNextPos, Val), !
	;
	evaluateMove(Tab, Player, Move, Value, Length).

best(Tab, Player, [Pos], Pos, Val) :-
		minimax(Tab, Player, Pos, _, Val), !.

best(Tab, Player, [Pos1 | PosList], BestPos, BestVal) :-
		minimax(Tab, Player, Pos1, _, Val1), 
		best(Tab, Player, PostList, Pos2, Val2),
		betterOf(Pos1, Val1, Pos2, Val2, BestPos, BestVal).

%betterOf(Pos0, Val0, _, Val1, Pos0, Val0):-


		