:- use_module(library(lists)).
:- dynamic map/2.
/**
			===================================
			======= Movement Translate ========
			===================================
	the user inputs a number from the numpad.
	the movement direction will follow the one from the numpad,
	e.g., 1 means down and left. so we have to go back in the columns 
	and forward in the rows, that menans 1 becomes -> (col: -1, row: 1).
**/
colTranslate(1, -1).
colTranslate(2, 0).
colTranslate(3, 1).
colTranslate(4, -1).
colTranslate(6, 1).
colTranslate(7, -1).
colTranslate(8, 0).
colTranslate(9, 1).

rowTranslate(1, 1).
rowTranslate(2, 1).
rowTranslate(3, 1).
rowTranslate(4, 0).
rowTranslate(6, 0).
rowTranslate(7, -1).
rowTranslate(8, -1).
rowTranslate(9, -1).

/*
			===================================
*/



/**
			===================================
			=== Matrix Operations Utilities ===
			===================================
 **/

replaceElemMatrix(0, Col, Elem, [L|Ls], [R|Ls]):-
	replaceElemCol(Col, Elem, L, R).

replaceElemMatrix(Row, Col, Elem, [L|Ls], [L|Rs]):-
	Row > 0, 
	NRow is Row - 1, 
	replaceElemMatrix(NRow, Col, Elem, Ls, Rs).

replaceElemCol(0, Elem , [_|Cs], [Elem|Cs]).

replaceElemCol(Col, Elem, [C|Cs], [C|Rs]):-
	Col > 0, 
	NCol is Col - 1, 
	replaceElemCol(NCol, Elem, Cs, Rs).

getPiece(Row, Col, Board, Elem):-
	nth0(Row, Board, RowList),
	nth0(Col, RowList, Elem).

getRowN([H|_], 0, H):- !.

getRowN([_|T], N, X) :-
	N1 is N - 1, 
	getRowN(T, N1, X).

getColumnN([], _, []).

getColumnN([H|T], N, [R|X]):-
	getRowN(H, N, R),
	getColumnN(T, N, X).


getColumns(Tab, Lenght, Cols):-
	findall(C, (between(0, Lenght, I), getColumnN(Tab, I, C)), Cols).


getDiagonal(Board, Diag, UpDiag, SecDiag, SecUpDiag, Offset):-
	length(Board, K), 
	N is K - 1,
	findall(A, (between(Offset, N, I), nth0(I, Board, Row), I2 is I - Offset, nth0(I2, Row, A)), Diag),
	findall(B, (between(Offset, N, I), nth0(I, Board, Row), J is N - I + Offset, nth0(J, Row, B)), SecDiag ),
	NegativeOffset is 0 - Offset, 
	findall(C, (between(NegativeOffset, N, I), nth0(I, Board, Row),  I2 is I - NegativeOffset, nth0(I2, Row, C)), UpDiag),
	findall(D, (between(Offset, N, I), I1 is I - Offset, nth0(I1, Board, Row), J is N - I, nth0(J, Row, D)), SecUpDiag).


sublist( Sublist, List ) :-
    append( [_, Sublist, _], List ).

checkEmpty(Board,NextRow,NextCol):-
	getPiece(NextRow, NextCol, Board, NextPiece), 
	NextPiece=:=0.

/*
			===================================
*/




/**
			===================================
			== Movement Operations Utilities ==
			===================================
 **/
checkBoundaries(Position, Lenght):-
	LengthArray is Lenght - 1, 
	(
		Position < 0, Position = 0, !;
		Position > LengthArray, Position = LengthArray, !;
		true
	).


movePiece(Row, Col, Move, Piece, Board, OutBoard):-
	colTranslate(Move, MoveCol),
	rowTranslate(Move, MoveRow),
	replaceElemMatrix(Row, Col, 0, Board, NBoard),
	length(Board, N),
	movePiece(Row, Col, MoveCol, MoveRow, Piece, NBoard, OutBoard, N).

movePiece(Row, Col, MoveCol, MoveRow, Piece, Board, OutBoard, BoardLength):-
	NextRow is Row + MoveRow, 
	NextCol is Col + MoveCol, 
	checkBoundaries(NextRow, BoardLength),
	checkBoundaries(NextCol, BoardLength),
	getPiece(NextRow, NextCol, Board, NextPiece), 
	NextPiece = 0 -> movePiece(NextRow, NextCol, MoveCol, MoveRow, Piece, Board, OutBoard, BoardLength);
					 replaceElemMatrix(Row, Col, Piece, Board, OutBoard).

valid_move(Board,Player,Row,Col,Move, Piece):-
	between(1, 9, Move),
	Move \= 5,
	Piece =:= (Player + 1),
	colTranslate(Move, MoveCol),
	rowTranslate(Move, MoveRow),
	NextRow is Row + MoveRow, 
	NextCol is Col + MoveCol, 
	length(Board, BoardLength),
	checkBoundaries(NextRow, BoardLength),
	checkBoundaries(NextCol, BoardLength),
	checkEmpty(Board,NextRow,NextCol). 

valid_moves(Board, Player, MovesList):-
	NPiece is Player + 1, 
	findall([Row, Col, Move], ( getPiece(Row, Col, Board, NPiece), 
								valid_move(Board, Player, Row, Col, Move, NPiece)), 
								MovesList).

move_and_evaluate(Board, Player, MovesList):-
	length(Board, N),
	K is N - 1, 
	NPiece is Player + 1, 
	findall([Value, Row, Col, Move],( getPiece(Row, Col, Board, NPiece), 
								valid_move(Board, Player, Row, Col, Move, NPiece), 
								movePiece(Row, Col, Move, NPiece, Board, OutTab),
								evaluateBoard(OutTab, Player, Value, K)), Moves),
	sort(Moves, TempMoves),
	reverse(TempMoves, MovesList).
/*
			===================================
*/

/**
			===================================
			========== Draw Conditions ========
			===================================
 **/


checkDraw(Tab):-

	flatten2(Tab, List),

	(
		retract( map(List,N) ),
		NewN is N + 1,
		assertz( map(List, NewN) );
		NewN is 1, 
		assertz(map(List, NewN))
	), 
	NewN > 2.
	

flatten2([], []):- !.
flatten2([L|Ls], Flat):-
	!,
	flatten2(L, NewL),
	flatten2(Ls, NewLs),
	append(NewL, NewLs, Flat).
flatten2(L, [L]).


drawGame:-
	write('The same position occurred 3 times!'), nl, 
	write('This match is a draw!'), nl, 
	mainMenu.


/**
			===================================
			======== Victory Conditions =======
			===================================
 **/

checkVictory(Tab, Player, Length):-
	
	K is Length - 1,
	(
		checkColumns(Tab, Player, K);
		checkRows(Tab, Player, K);
		checkBiggerDiagonals(Tab, Length, Player)
	).

wonGame(Player):-
	write('Player '), write(Player), write(' won!'), nl, 
	mainMenu.

isConnected(Player, List):-
	Piece is Player + 1,
	sublist([Piece, Piece, Piece], List).

checkColumns(Tab, Player, N):-
	between(0, N, N1), 
	getColumnN(Tab, N1, Col), 
	isConnected(Player, Col).

checkRows(Tab, Player, N):-
	between(0, N, N1), 
	nth0(N1, Tab, Row), 
	isConnected(Player, Row).

checkBiggerDiagonals(Tab, Length, Player):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Tab, D, UpD, SecD, SecUpD, Offset),  
	(
		isConnected(Player, D);
		isConnected(Player, UpD);
		isConnected(Player, SecD);
		isConnected(Player, SecUpD)
	).

/*
			===================================
*/