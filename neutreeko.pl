encoding('unicode_be').

translate(0, ' ').
translate(1, 'W').
translate(2, 'B').


tab([[0, 1, 0, 1, 0],
    [0, 0, 2, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 0, 0],
    [0, 2, 0, 2, 0]]).
    

print_tab([]).
print_tab([L|T]):-
	print_line(L),
	nl,
	print_tab(T).

print_line([]):- write('|').
print_line([C|L]):-
	print_cell(C),
	print_line(L).

print_cell(C):-
	translate(C, V),
	format('|_~w_~t', V).


main:- tab(Tab),
	print_tab(Tab).
