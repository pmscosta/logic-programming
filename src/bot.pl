:- use_module(library(lists)).
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
		valid_moves(Tab, Player, MovesList),
		nextPlayer(Player, NextPlayer), 
		valid_moves(Tab, NextPlayer, EnemyMoves),
		length(MovesList, N),
		length(EnemyMoves, E),
		K = [N, -E],
		append(Score, K, Score2),
		sumlist(Score2, Value)
	).

evaluateMove(Tab, Player, Move, Value, Length, OutTab):-
	Move = [Row, Col, Move],
	Piece is Player + 1,
	movePiece(Row, Col, Move, Piece, Tab, OutTab),
	evaluateBoard(OutTab, Player, Value, Length).


checkTwoConnected(Tab, Player, Length):-
	K is Length - 1,
	(
		checkTwoColumns(Tab, Player, K);
		checkTwoRows(Tab, Player, K);
		checkTwoBiggerDiagonals(Tab, Player, Length)
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

checkTwoBiggerDiagonals(Tab, Player, Length):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Tab, D, UpD, SecD, SecUpD, Offset), 
	(
	isTwoConnected(Player, D);
	isTwoConnected(Player, UpD);
	isTwoConnected(Player, SecD);
	isTwoConnected(Player, SecUpD)
	).
    
/*
			===================================
*/


/**
			===================================
			======== Minimax ALgorithm ========
			===================================
 **/

minimax(Tab, Player, State, Depth, NextVal, NextTab):-

	Depth > 0, 
	NewDepth is Depth - 1,
	valid_moves(Tab, Player, MovesList), 
	best(Tab, Player, State, MovesList, NewDepth, NextTab, NextVal), !
	;
	length(Tab, Length), 
	evaluateBoard(Tab, Player, NextVal, Length), 
	NextTab = Tab.

best(Tab, Player, State, [Move], Depth, BestTab, BestVal):- 

	Move = [Row, Col, Dir], 
	Piece is Player + 1, 

	movePiece(Row, Col, Dir, Piece, Tab, OutTab),

	nextTurn(Player, State, NextPlayer, NextState),

	minimax(OutTab, NextPlayer, NextState, Depth, BestVal, BestTab), !.

best(Tab, Player, State, [Move | NextMoves], Depth, BestTab, BestVal):-


	Move = [Row, Col, Dir], 
	Piece is Player + 1, 

	movePiece(Row, Col, Dir, Piece, Tab, OutTab),

	nextTurn(Player, State, NextPlayer, NextState),

	minimax(OutTab, NextPlayer, NextState, Depth, Val1, Tab1), 

	best(Tab, Player, State, NextMoves, Depth, Tab2, Val2), 

	betterOf(OutTab, Val1, OutTab, Val2, BestTab, BestVal, State).


betterOf(Tab1, Val1, _, Val2, Tab1, Val1, State) :-   
    State = 1,                         
    Val1 > Val2, !                             
    ;
    State = 0,                         
    Val1 < Val2, !.                            

betterOf(_, _, Tab2, Val2, Tab2, Val2, _).      


nextTurn(Player, State, NextPlayer, NextState):-
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	NState is State + 1, 
	NextState is mod(NState, 2).
  


		