:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(lists)).

number_of_digits(Number, Digits):-
    X = log(10, Number) + 1,
    Digits is floor(X).

createExpList([_]).

createExpList([A, B | C]):-
B #= A * 10, 
createExpList([B | C]).

maxValue(First, Mult, Elems, Max):-
Exp = Elems - 1, 
Max is floor(First * ( Mult ** Exp)).


retractNumber(Number, ExpList, Subtract, Exp):-
Number #\= Subtract,
element(_, ExpList, Exp),
Subtract #= ( Number // (10 * Exp) ) * Exp + (Number mod Exp).

addConstraints([_], _, _,List, List).

addConstraints([A, B | C], Mult, ExpList, ExpAcc, Exponents):-
retractNumber(A, ExpList, SubtractNumber, Exp),
(B #= A * Mult #/\ Exp #= 1) #\/ (A #>= 10 #/\ B #= SubtractNumber),
append(ExpAcc, [Exp], NExpAcc),
addConstraints([B | C], Mult, ExpList, NExpAcc, Exponents).

sel_var(leftmost).
sel_var(max).
sel_var(min).
sel_var(max).
sel_var(ff).
sel_var(ffc).
sel_var(anti_first_fail).
sel_var(max_regret).


sel_order(up).
sel_order(down).


sel_value(step).
sel_value(enum).
sel_value(bisect).
sel_value(middle).
sel_value(median).

values([2, 6, 5]).
values([9, 2, 8]).
values([46, 2, 7]).
values([22, 2, 9]).
values([26, 2, 9]).
values([2, 3, 5]).
values([22, 3, 6]).
values([31, 3, 9]).
values([11, 3, 11]).
values([7, 6, 5]).
values([13, 6, 8]).
values([11, 6, 7]).
values([17, 6, 7]).
values([12, 7, 6]).
values([27, 7, 7]).
values([17, 7, 7]).
values([41, 7, 8]).




best_option([leftmost,step,up]          ).   
best_option([leftmost,bisect,up]        ).     
best_option([leftmost,bisect,down]      ).     
best_option([leftmost,middle,up]        ).   
best_option([leftmost,median,up]        ). 
best_option([min,bisect,up]             ).
best_option([min,bisect,down]           ).
best_option([anti_first_fail,bisect,up] ).
best_option([max_regret,step,up]        ).
best_option([max_regret,bisect,up]      ).
best_option([max_regret,bisect,down]    ).
best_option([max_regret,middle,up]      ).
best_option([max_regret,median,up]      ).