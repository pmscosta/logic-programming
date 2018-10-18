:- use_module(library(lists)).

translate(0, ' ').
translate(1, 'W').
translate(2, 'B').


tab([[0, 1, 0, 1, 0],
    [0, 0, 2, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 2, 0, 2, 0]]).
    

print_tab([]).
print_tab([L|T], 1):-
	print_line(L),
	nl,
	print_tab(T).

print_tab([L|T], N):-
	print_line(L),
	nl,
	N > 0,
	print_hor_div(L),
	N1 is N - 1,
	print_tab(T, N1).

print_hor_div(L):-
	put_code(0x251C),
	print_div(L),
	nl.

print_div([]).
print_div([_|[]]):- 
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2524),
	print_div([]).
print_div([_|L]):-
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x253C),
	print_div(L).


print_line([]):- 
	put_code(0x2502).
print_line([C|L]):-
	print_cell(C),
	print_line(L).
print_cell(C):-
	translate(C, V),
	put_code(0x2502),
	put_code(0x2003),
	write(V),
	put_code(0x2003).



top_wall([L|_]):-
	put_code(0x250C),
	print_top_wall(L).

print_top_wall([]):- nl.
print_top_wall([_|L]):-
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2500),
	print_top_last([_|L]).

print_top_last([_|[]]):-
	put_code(0x2510),
	print_top_wall([]).
print_top_last([_|L]):-
	put_code(0x252C),
	print_top_wall(L).


bot_wall([L|_]):-
	put_code(0x2514),
	print_bot_wall(L).

print_bot_wall([]).
print_bot_wall([_|L]):-
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2500),
	print_bot_last([_|L]).

print_bot_last([_|[]]):-
	put_code(0x2518),
	print_bot_wall([]).
print_bot_last([_|L]):-
	put_code(0x2534),
	print_bot_wall(L).




main:- tab(Tab),
	top_wall(Tab),
	length(Tab, N),
	print_tab(Tab, N),
	bot_wall(Tab).
