:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).
:- include('utilities.pl').
:- include('display.pl').
:- include('boardCreator.pl').
:- include('boardManipulation.pl').
:- include('menus.pl').


evaluateBoard(Tab, Player, Value, Length):-
	(
		checkVictory(Player, Tab, Length),	Value = 100;
		findall(B, ( checkTwoConnected(Player, Tab, Length), B = 10 ), Score),
		sumlist(Score, Value)
	).

isTwoConnected(Player, List):-
	Piece is Player + 1, 
	sublist([Piece, Piece], List).


checkTwoColumns(Player, Tab, N):-
	between(0, N, N1), 
	getColumnN(Tab, N1, Col), 
	isTwoConnected(Player, Col).

checkTwoRows(Player, Tab, N):-
	between(0, N, N1), 
	nth0(N1, Tab, Row), 
	isTwoConnected(Player, Row).

checkTwoBiggerDiagonals(Tab, Length):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Tab, Diagonal, Offset), 
	isTwoConnected(0, Diagonal). 

checkTwoConnected(Player, Tab, Length):-
	K is Length - 1,
	(
		checkTwoColumns(Player, Tab, K);
		checkTwoRows(Player, Tab, K);
		checkTwoBiggerDiagonals(Tab, Length)
	).


isConnected(Player, List):-
	Piece is Player + 1,
	sublist([Piece, Piece, Piece], List).

checkColumns(Player, Tab, N):-
	between(0, N, N1), 
	getColumnN(Tab, N1, Col), 
	isConnected(Player, Col).

checkRows(Player, Tab, N):-
	between(0, N, N1), 
	nth0(N1, Tab, Row), 
	isConnected(Player, Row).

checkBiggerDiagonals(Tab, Length):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Tab, Diagonal, Offset), 
	isConnected(0, Diagonal). 


checkVictory(Player, Tab, Length):-
	K is Length - 1,
	(
		checkColumns(Player, Tab, K);
		checkRows(Player, Tab, K);
		checkBiggerDiagonals(Tab, Length)
	).


startPvPGame:-
	tab(Tab),
	Player is 1,
	playPvPGame(Tab, Player).

startPvBGame:-
	tab(Tab),
	Player is 1, 
	playPvBGame(Tab, Player).

startBvBGame(Mode):-
	tab(Tab), 
	Player is 1, 
	playBvBGame(Tab, Player, Mode).

playBvBGame(Tab, Player, Mode):-
	length(Tab, N),
	display_board(Tab),
	(
		Mode = 1, botPlay(Tab, Player, OutTab);
		Mode = 2, botPlayGreedy(Tab, Player, OutTab)

	),
	(checkVictory(Player, OutTab, N) -> display_board(OutTab), wonGame(Player); true ),
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	playBvBGame(OutTab, NextPlayer, Mode).


playPvBGame(Tab, Player):-
	length(Tab, N),
	display_board(Tab),
	(
		Player = 1, 
			(
				askUserInput(Row, Col, N),
				askUserMove(Move),
				getPiece(Row, Col, Tab, Piece),
				valid_move(Tab,Player,Row,Col,Move,Piece),
				movePiece(Row, Col, Move, Piece, Tab, OutTab)
				;
				write('Invalid Move!'), nl, 
				NextPlayer = Player, OutTab = Tab, !, 
				playPvBGame(OutTab, Player)
			)
		;
		botPlay(Tab, Player, OutTab)
	),
	(checkVictory(Player, OutTab, N) -> display_board(OutTab), wonGame(Player); true ),
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	playPvBGame(OutTab, NextPlayer).

playPvPGame(Tab, Player):-
	length(Tab, N),
	display_board(Tab),
	askUserInput(Row, Col, N),
	askUserMove(Move),
	(
		getPiece(Row, Col, Tab, Piece),
		valid_move(Tab,Player,Row,Col,Move,Piece),
		movePiece(Row, Col, Move, Piece, Tab, OutTab),
		(checkVictory(Player, OutTab, N) -> display_board(OutTab), wonGame(Player); true ),
		NPlayer is Player + 1,
		NextPlayer is mod(NPlayer, 2), 
		write('NextPlayer:'), write(NextPlayer), nl, !
		;	
		write('Invalid Move!'), nl, NextPlayer = Player, OutTab = Tab 
	),
	playPvPGame(OutTab, NextPlayer).


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

	

wonGame(Player):-
	write('Player '), write(Player), write(' won!'), nl, 
	mainMenu.

main:- 
	mainMenu.
