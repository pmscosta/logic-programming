:- use_module(library(lists)).

translate(0, 0x2003).
translate(1, 0xFFEE).
translate(2, 0xFFED).

div_line_bold:-
	put_code(0x2501),
	put_code(0x2501),
	put_code(0x2501).
div_line:-
	put_code(0x2500),
	put_code(0x2500),
	put_code(0x2500).

write_ident(A):-
	write(A),
	write(' ').

print_tab([]).
print_tab([L|T], 1):-
	write_ident(1),	
	print_line(L),
	print_tab(T).

print_tab([L|T], N):-
	write_ident(N),
	print_line(L),
	N > 0,
	print_hor_div(L),
	N1 is N - 1,
	print_tab(T, N1).

print_hor_div(L):-
	write('  '),
	put_code(0x251C),
	print_div(L),
	nl.

print_div_line(C):-
	div_line,
	put_code(C).

print_div([]).
print_div([_|[]]):-
	print_div_line(0x2524), 
	print_div([]).
print_div([_|L]):-
	print_div_line(0x253C),
	print_div(L).


print_line([]):- 
	put_code(0x2502), nl.
print_line([C|L]):-
	print_cell(C),
	print_line(L).
print_cell(C):-
	translate(C, V),
	put_code(0x2502),
	put_code(0x2003),
	put_code(V),
	put_code(0x2003).

top_number([L|_], N):-
	write('  '),
	A is 0x41,
	print_top_number(L, N, A).

print_top_number(_, 0, _):- nl.
print_top_number([_|L], N, A):-
	write('  '),
	put_code(A),
	write(' '),
	N1 is N - 1, 
	A1 is A + 1, 
	print_top_number([_|L], N1, A1).

top_wall([L|_]):-
	write('  '),
	put_code(0x250F),
	print_top_wall(L).

print_top_wall([]):- nl.
print_top_wall([_|L]):-
	div_line_bold,
	print_top_last([_|L]).

print_top_last([_|[]]):-
	put_code(0x2513),
	print_top_wall([]).
print_top_last([_|L]):-
	put_code(0x252F),
	print_top_wall(L).


bot_wall([L|_], N):-
	write('  '),
	put_code(0x2517),
	print_bot_wall(L),
	top_number([L|_], N).

print_bot_wall([]):- nl.
print_bot_wall([_|L]):-
	div_line_bold,
	print_bot_last([_|L]).

print_bot_last([_|[]]):-
	put_code(0x251B),
	print_bot_wall([]).
print_bot_last([_|L]):-
	put_code(0x2537),
	print_bot_wall(L).

/**


**/
display_board(Board):-
	length(Board, N),
	top_wall(Board),
	print_tab(Board, N),
	bot_wall(Board, N).