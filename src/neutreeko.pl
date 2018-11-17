:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).
:- include('userInput.pl').
:- include('display.pl').
:- include('boardCreator.pl').
:- include('boardLogic.pl').
:- include('menus.pl').
:- include('bot.pl').


/**
			===================================
			========= Player vs Player ========
			===================================
 **/

startPvPGame:-
	tab(Tab),
	Player is 1,
	playPvPGame(Tab, Player).

playPvPGame(Tab, Player):-
	cls,
	length(Tab, N),
	display_board(Tab),
	askUserInput(Row, Col, N),
	askUserMove(Move),
	(
		getPiece(Row, Col, Tab, Piece),
		valid_move(Tab,Player,Row,Col,Move,Piece),
	move([Row, Col, Move], Piece, Tab, OutTab),
	(
			checkVictory(OutTab, Player, N), 
			display_board(OutTab), 
			wonGame(Player)
			; 
			checkDraw(OutTab),
			display_board(OutTab),
			drawGame
			;
			nextPlayer(Player, NextPlayer),
			playPvPGame(OutTab, NextPlayer)
	).



/**
			===================================
			========== Player vs Bot ==========
			===================================
 **/

startPvBGame(Mode):-
	tab(Tab),
	Player is 1, 
	playPvBGame(Tab, Player, Mode).

playPvBGame(Tab, Player,Mode, FirstPlayer):-
	
	length(Tab, N),
	display_board(Tab),
	(
		Player = FirstPlayer, 
		repeat,
			askUserInput(Row, Col, N),
			askUserMove(Move),
			getPiece(Row, Col, Tab, Piece),
			valid_move(Tab,Player,Row,Col,Move,Piece),
		move([Row, Col, Move], Piece, Tab, OutTab)
		;
		Mode = 1, botPlay(Tab, Player, OutTab)
		;
		Mode = 2, botPlayGreedy(Tab, Player, OutTab)
		;
		Mode = 3, minimax(Tab, Player, 1, 2, _, OutTab)	
	),
	(checkVictory(OutTab, Player, N) -> display_board(OutTab), wonGame(Player); true ),
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	playPvBGame(OutTab, NextPlayer, Mode).



/**
			===================================
			============ Bot vs Bot ===========
			===================================
 **/


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
		;
		Mode = 3, minimax(Tab, Player, 1, 2, _, OutTab)
	),
	(
			checkVictory(OutTab, Player, N), 
			display_board(OutTab), 
			wonGame(Player)
			; 
			checkDraw(OutTab),
			display_board(OutTab),
			drawGame
			;
			nextPlayer(Player, NextPlayer),
			playBvBGame(OutTab, NextPlayer, Mode)
	).

	),
	(checkVictory(OutTab, Player, N) -> display_board(OutTab), wonGame(Player); true ),
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2), 
	playBvBGame(OutTab, NextPlayer, Mode).


main:- 
	mainMenu.
