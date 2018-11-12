:- use_module(library(lists)).
:- use_module(library(between)).
:- include('utilities.pl').
:- include('display.pl').
:- include('boardCreator.pl').
:- include('boardManipulation.pl').
:- include('menus.pl').


isConnected(Player, Row):-
	Piece is Player + 1,
	sublist([Piece, Piece, Piece], Row).

checkColumns(Player, Board, N):-
	between(0, N, N1), 
	getColumnN(Board, N1, Col), 
	isConnected(Player, Col).

checkRows(Player, Board, N):-
	between(0, N, N1), 
	nth0(N1, Board, Row), 
	isConnected(Player, Row).

checkBiggerDiagonals(Board, Length):-
	K is Length - 2,
	between(0, K, Offset), 
	getDiagonal(Board, Diagonal, Offset), 
	nl, write(Diagonal), nl,
	isConnected(0, Diagonal). 


checkVictory(Player, Board, Length):-
	K is Length - 1,
	(
		checkColumns(Player, Board, K);
		checkRows(Player, Board, K);
		checkBiggerDiagonals(Board, Length)
	).


startGame:-
	tab(Tab),
	Player is 1,
	playGame(Tab, Player).

playGame(Tab, Player):-
	length(Tab, N),
	display_board(Tab),
	askUserInput(Row, Col, N),
	askUserMove(Move),
	getPiece(Row, Col, Tab, Piece),
	movePiece(Row, Col, Move, Piece, Tab, OutTab),
	( checkVictory(Player, OutTab, N) -> wonGame(Player); true ), 
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	write('NextPlayer:'), write(NextPlayer), nl, 
	playGame(OutTab, NextPlayer).

wonGame(Player):-
	write('Player '), write(Player), write(' won!'), nl, 
	mainMenu.

main:- 
	mainMenu.
