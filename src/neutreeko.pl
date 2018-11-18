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


/**
 * startPvPGame
 * 
 * Initiates a Player vs Player Game
 * 
 * Creates the Board , creates the player and calls the game main cycle 
 * 
 * */
startPvPGame:-
	tab(Tab),
	Player is 1,
	assertz(map(Tab, 1)),    %storing the initial board in the map predicate to check for draws
	playPvPGame(Tab, Player).


/**
 * playPvPGame(+Tab, +Player)
 * 
 * PvP Game Cycle
 * 
 * This functions handles all of the game iterations.
 * Asks for the user input, makes the moves until the finished game conditions are met.
 */
playPvPGame(Tab, Player):-
	cls,
	length(Tab, N),
	display_board(Tab),
	announcePlayer(Player),
	repeat,  
		askUserInput(Row, Col, N),
		askUserMove(Move),
		getPiece(Row, Col, Tab, Piece),
		valid_move(Tab,Player,Row,Col,Move,Piece),
	move([Row, Col, Move], Piece, Tab, OutTab),
	(
			game_over(OutTab, Player, N), 
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

startPvBGame(Mode, FirstPlayer):-
	tab(Tab),
	Player = 1,
	assertz(map(Tab, 1)),
	playPvBGame(Tab, Player, Mode, FirstPlayer).

playPvBGame(Tab, Player,Mode, FirstPlayer):-
	cls,
	length(Tab, N),
	display_board(Tab),
	announcePlayer(Player),
	(
		Player = FirstPlayer, 
		repeat,
			askUserInput(Row, Col, N),
			askUserMove(Move),
			getPiece(Row, Col, Tab, Piece),
			valid_move(Tab,Player,Row,Col,Move,Piece),
		move([Row, Col, Move], Piece, Tab, OutTab)
		;
		Mode = 1, botPlay(Tab, Player, 1,  OutTab)
		;
		Mode = 2, botPlay(Tab, Player, 2, OutTab)
		;
		Mode = 3, minimax(Tab, Player, 1, 2, _, OutTab)	
	),
	(
		game_over(OutTab, Player, N), 
		display_board(OutTab), 
		wonGame(Player)
		; 
		checkDraw(OutTab),
		display_board(OutTab),
		drawGame
		;
		nextPlayer(Player, NextPlayer),
		playPvBGame(OutTab, NextPlayer, Mode, FirstPlayer)
	).



/**
			===================================
			============ Bot vs Bot ===========
			===================================
 **/


startBvBGame(Mode):-
	tab(Tab), 
	Player is 1, 
	assertz(map(Tab, 1)),
	playBvBGame(Tab, Player, Mode).

playBvBGame(Tab, Player, Mode):-
	cls,
	length(Tab, N),
	display_board(Tab),
	(
		Mode = 1, botPlay(Tab,Player,1,OutTab)
		;
		Mode = 2, botPlay(Tab,Player,2,OutTab)
		;
		Mode = 3, minimax(Tab, Player, 1, 2, _, OutTab)
	),
	(
			game_over(OutTab, Player, N), 
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

/**
 * nextPlayer(+Player, -NextPlayer)
 * 
 * States the next player to play in the next round
 */
nextPlayer(Player, NextPlayer):-
	NPlayer is Player + 1,
	NextPlayer is mod(NPlayer, 2).

play:- 
	mainMenu.