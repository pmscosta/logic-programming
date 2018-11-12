:- use_module(library(lists)).
:- include('utilities.pl').
:- include('display.pl').
:- include('boardCreator.pl').
:- include('boardManipulation.pl').
:- include('menus.pl').


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
	playGame(OutTab, Player).

main:- 
	mainMenu.
