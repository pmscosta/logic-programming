:- use_module(library(lists)).
:- include('utilities.pl').
:- include('display.pl').
:- include('boardCreator.pl').
:- include('boardManipulation.pl').


playGame(Tab, Player):-
	tab(Tab),
	length(Tab, N),
	display_board(Tab),
	askUserInput(X, Y, N),
	get(X, Y, Tab, Elem),
	write(Elem), nl,
	playGame(Tab, Player).

main:- 
	tab(Tab),
	playGame(Tab, Player).

