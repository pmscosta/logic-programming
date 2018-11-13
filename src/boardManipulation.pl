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
	( NextPiece = 0; NextPiece = 0, NextRow = 0, NextCol = 0; NextCol = BoardLength, NextRow = BoardLength, NextPiece = 0 )
				-> movePiece(NextRow, NextCol, MoveCol, MoveRow, Piece, Board, OutBoard, BoardLength) ; 
					replaceElemMatrix(Row, Col, Piece, Board, OutBoard).


getRowN([H|_], 0, H):- !.
getRowN([_|T], N, X) :-
	N1 is N - 1, 
	getRowN(T, N1, X).

getColumnN([], _, []).
getColumnN([H|T], N, [R|X]):-
	getRowN(H, N, R),
	getColumnN(T, N, X).



getDiagonal(Board, Diagonal, Offset):-
	length(Board, K), 
	N is K - 1,
	findall(B, (between(Offset, N, I), nth0(I, Board, Row), I2 is I - Offset, nth0(I2, Row, B)), Diagonal).

sublist( Sublist, List ) :-
    append( [_, Sublist, _], List ).