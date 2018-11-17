:- use_module(library(lists)).
/**
			===================================
			========= Bot Play Levels =========
			===================================
 **/

/**
 * botPlay(+Tab, +Player, -OutTab).
 * Plays the random bot 
 * Calculates all the possible moves and selects a random one.
 * @param Tab - Current Board
 * @param Player - Current Player
 * @param OutTab - Board after bot play
 **/
botPlay(Tab, Player, OutTab):-
	valid_moves(Tab, Player, MovesList),
	length(MovesList, L), 
	random(0, L, Index), 
	nth0(Index, MovesList, Move), 
	Move = [Row, Col, Dir], 
	Piece is Player + 1, 
	move([Row, Col, Dir], Piece, Tab, OutTab).

/**
 * botPlayGreedy(+Tab, +Player, -OutTab).
 * Plays the greedy bot 
 * Following the heuristic present in evaluateBoard(+Tab, +Player, -Value, +Length)
 * it calculates all the possible moves, evaluating them.
 * Then it selects the best future move, based on such evaluation, and makes it.
 * @param Tab - Current Board
 * @param Player - Current Player
 * @param OutTab - Board after bot play
 **/

botPlayGreedy(Tab, Player, OutTab):-
	move_and_evaluate(Tab, Player, MovesList),
	nth0(0, MovesList, Move), 
	Move = [_, Row, Col, Dir], 
	Piece is Player + 1, 
	move([Row, Col, Dir], Piece, Tab, OutTab).

/*
			===================================
*/




/**
			===================================
			===== Bot Heuristic Functions =====
			===================================
 **/

/*
 * evaluateBoard(+Tab, +Player, -Value, +Length).
 * Evaluates the board following an heuristic.
 * The heuristcs takes in consideration the following main points:
 * 			-if it can win with such moves, gives it the highest value possible, 1000.
 *          -gives 15 points for each two pieces connected (be it in a row, column or diagonal)
 *          -calculates how many other valid moves there are after that board and adds it to score
 * 					(if there are 10 valid moves after, value += 10)
 * 			-does the same as the previous point, but for enemy moves, subtracting that valeu
 * @param Tab - Board to evaluate
 * @param Player - Current Player
 * @param Value - Board value following the heuristic
 * @param Length - Length of the board
*/
evaluateBoard(Tab, Player, Value, Length):-
		checkVictory(Tab, Player, Length),	Value = 1000;
		checkTwoConnected(Tab, Player, Length, Total),
		Total15 is Total * 15, 
		valid_moves(Tab, Player, MovesList),
		nextPlayer(Player, NextPlayer), 
		valid_moves(Tab, NextPlayer, EnemyMoves),
		length(MovesList, N),
		length(EnemyMoves, E),
		Value is Total15 + N - E.

/**
 * evaluateMove(+Tab, +Player, +Move, -Value, +Length, -OutTab).
 * Evaluates a move following an heuristic
 * @param Tab - Current Board 
 * @param Player - Current Player 
 * @param Move - Move to evaluate 
 * @param Value - Value from taking the move following the heuristic
 * @param Length - Length of the board
 * @param OutTab - Board after taking the move    
 **/
evaluateMove(Tab, Player, Move, Value, Length, OutTab):-
	Move = [Row, Col, Move],
	Piece is Player + 1,
	move([Row, Col, Move], Piece, Tab, OutTab),
	evaluateBoard(OutTab, Player, Value, Length).


/**
 * checkTwoConnected(+Tab, +Player, +Length).
 * Checks if there are two pieces connected, horizontally,
 * vertically or diagonally
 * @param Tab - Current Tab
 * @param Player - Current Player
 * @param Length - Length of the board
 **/
checkTwoConnected(Tab, Player, Length, TotalConnected):-
	K is Length - 1,
	!,
	checkTwoColumns(Tab, Player, K, Value1),
	checkTwoRows(Tab, Player, K, Value2),
	checkTwoBiggerDiagonals(Tab, Player, K, Value3),
	TotalConnected is Value1 + Value2 + Value3.	


/**
 * isTwoConnected(+Player, +List).
 * Verifies if there are two same pieces connected, by receiving a list of a line (diagonal, horizontal or vertical)
 * @param Player - Current Player
 * @param List - List of a diagonal or row or column from board
 **/
isTwoConnected(Player, List):-
	Piece is Player + 1, 
	sublist([Piece, Piece], List).

/**
 *checkTwoColumns(+Tab, +Player, +Length).
 * Checks if there is two pieces connected together in two columns
 * @param Tab - Current Board
 * @param Player - Current Player
 * @param Length - Board Length 
 **/
checkTwoColumns(Tab, Player, Length, Value):-
	findall( B,(between(0, Length, N1), getColumnN(Tab, N1, Col), isTwoConnected(Player, Col), B=1), List), 
	sumlist(List, Value).

/**
 *checkTwoRows(+Tab, +Player, +Length).
 * Checks if there is two pieces connected together in two rows
 * @param Tab - Current Board
 * @param Player - Current Player
 * @param Length - Board Length 
 **/
checkTwoRows(Tab, Player, Length, Value):-
	findall(B, (between(0, Length, N1), nth0(N1, Tab, Row), isTwoConnected(Player, Row), B=1), List), 
	sumlist(List, Value).


checkTwoBiggerDiagonals(Tab, Player, Length, Value):-
	K is Length - 2,
	findall(B , (between(0, K, Offset), getDiagonal(Tab, D, UpD, SecD, SecUpD, Offset), 
											(
											isTwoConnected(Player, D);
											isTwoConnected(Player, UpD);
											isTwoConnected(Player, SecD);
											isTwoConnected(Player, SecUpD)
											), B=1 ), List),
	sumlist(List, Value).
    
/*
			===================================
*/


/**
			===================================
			======== Minimax ALgorithm ========
			===================================
 **/

/**
 * minimax(+Tab, +Player, +State, +Depth, -NextVal, -NextTab). 
 * Applies minimax algorithm to find best next play, returning the best board and respective value
 * @param Tab - Current Board
 * @param Player - Player that is gonna perform initial play 
 * @param State - Current State of the game, player to play, inside minimax 
 * @param Depth - Amount of levels for minimax
 * @param NextVal - Best value from taking a move (NextTab value)
 * @param NextTab - Best valued board from taking a move 
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


/**
 * best(+Tab, +Player, +State,+[Move], +Depth, -BestVal, -BestTab). 
 * Base case for best function, applies the last possible move.
 * @param Tab - Current Board
 * @param Player - Player that is gonna perform initial play 
 * @param State - Current State of the game, player to play, inside minimax 
 * @param Move - Next possible move to apply to Tab
 * @param Depth - Amount of levels for minimax
 * @param BestTab - Best valued board from taking the move 
 * @param BestVal - Best value from taking the move (NextTab value)
 **/
best(Tab, Player, State, [Move], Depth, BestTab, BestVal):- 

	Move = [Row, Col, Dir], 
	Piece is Player + 1, 

	move([Row, Col, Dir], Piece, Tab, OutTab),

	nextTurn(Player, State, NextPlayer, NextState),

	minimax(OutTab, NextPlayer, NextState, Depth, BestVal, BestTab), !.

/**
 * best(+Tab, +Player, +State,+[Move|NextMoves], +Depth, -BestVal, -BestTab). 
 * Iterates over all the possible moves from a specific state and board, returning the highest value one
 * @param Tab - Current Board
 * @param Player - Player that is gonna perform initial play 
 * @param State - Current State of the game, player to play, inside minimax 
 * @param [Move|NextMoves] - List of all possible moves to apply to Tab in current State
 * @param Depth - Amount of levels for minimax
 * @param BestTab - Best valued board from taking the move 
 * @param BestVal - Best value from taking the move (NextTab value)
 **/
best(Tab, Player, State, [Move | NextMoves], Depth, BestTab, BestVal):-

	Move = [Row, Col, Dir], 
	Piece is Player + 1, 

	move([Row, Col, Dir], Piece, Tab, OutTab),

	nextTurn(Player, State, NextPlayer, NextState),

	minimax(OutTab, NextPlayer, NextState, Depth, Val1, _), 

	best(Tab, Player, State, NextMoves, Depth, Tab2, Val2), 

	betterOf(OutTab, Val1, Tab2, Val2, BestTab, BestVal, State).



/**
 * betterOf(+Tab1, +Val1, _, +Val2, -Tab1, -Val1, +State). 
 * Checks if Tab1 is better valued than Tab2,if so returns Tab1 and respective value as best action
 * @param Tab1 - Board option 1
 * @param Val1 - Value from option 1
 * @param Val2 - Value from option 2
 * @param Tab1 - Best Board, in this case, Tab1
 * @param Val1 - Value from best board, Tab1
 * @param State - Player to move
 **/
betterOf(Tab1, Val1, _, Val2, Tab1, Val1, State) :-   
    State = 1,                         
    Val1 > Val2, !                             
    ;
    State = 0,                         
    Val1 < Val2, !.                            


/**
 * betterOf(_, _, Tab2, +Val2, -Tab1, -Val1, +State). 
 * If the other call of betterOf fails, it's Tab2 the best play, so this assigns Tab2 as the best action to take
 * @param Tab2 - Board option 2
 * @param Val2 - Value from option 2
 * @param Tab2 - Best Board, in this case, Tab2
 * @param Val2 - Value from best board, Tab2
 * @param State - Player to move
 **/
betterOf(_, _, Tab2, Val2, Tab2, Val2, _).      



/**
 * nextTurn(+Player, +State, -NextPlayer, -NextState).
 * Switches turns, updating Player and State
 * @param Tab - Current Board
 * @param Player - Player that played before
 * @param State - Past State
 * @param NextPlayer - Player updated
 * @param NextState - State updated 
 **/
nextTurn(Player, State, NextPlayer, NextState):-
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	NState is State + 1, 
	NextState is mod(NState, 2).
  


		