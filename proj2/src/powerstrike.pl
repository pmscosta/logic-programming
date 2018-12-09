:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(lists)).

maxValue(First, Mult, Elems, Max):-
    Exp = Elems - 1, 
    Max is floor(First * ( Mult ** Exp)), 
    printValues(First, Mult, Elems, Max).


addConstrains([_, _], _).

addConstrains([A, B | C], Mult):-
    B #= A * Mult, 
    addConstrains([B | C], Mult).


pstrike(First, Mult, Elems, Max):-
    
    length(Numbers, Elems),
    domain(Numbers, 0, Max),
    element(1, Numbers, First), 
    element(Elems, Numbers, First),
    addConstrains(Numbers, Mult),
    labeling([], Numbers), 
    write(Numbers).
    

    
printValues(First, Mult, Elems, Max):-
    write(First),nl, 
    write(Mult), nl,
    write(Elems), nl, 
    write(Max),nl.


play:-
    random(2, 20, Mult),
    random(0, 500, First),
    random(3, 10, Elems), 
    Circle is Elems + 1,
    maxValue(First, Mult, Elems, Max),
    pstrike(First, Mult, Circle, Max). 




/*  ======== SPLIT NUMBER ===============  */
numbers_atoms(Numbers, Atoms) :-
    maplist(atom_number, Atoms, Numbers).

digits_number(Digits, Number) :-
    numbers_atoms(Digits, Atoms),
    number_codes(Number, Atoms).