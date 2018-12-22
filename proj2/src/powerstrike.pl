
:- consult('gamelogic.pl').
:-use_module(library(timeout)).


writeResult(Label, Time):-
    write('Execution time: '), write(Time), write(' ms.'), nl,
    write('Result: '), write(Label), nl.

writeChosen(F, M, E, O):-
    format('First Element: ~w ~t Multiplier: ~w ~t Number of Elements: ~w~n Options: ~w ~n', [F, M, E, O]).
% - Random play of the Game
solve:-  
    repeat, 
    random(2, 20, Mult), 
    random(2, 80, First), 
    random(3, 11, Elems),
    best_option(Options),
    maxValue(First, Mult, Elems, Max),
    number_of_digits(Max, MaxDigits),
    length(ExpList, MaxDigits),
    element(1, ExpList, 1), 
    createExpList(ExpList),
    time_out(pstrike(First, Mult, Elems, Max, ExpList, Options, Label, Time), 2000, Result), 
    (
        Result = success, !,  writeChosen(First, Mult, Elems, Options), writeResult(Label, Time);
        fail
    ).


% - Starting the game with pre-defined labeling options.
solve(First, Mult, Elems, Options):-
    number(Mult), !, number(First), !, number(Elems), !,
    maxValue(First, Mult, Elems, Max),
    number_of_digits(Max, MaxDigits),
    length(ExpList, MaxDigits),
    element(1, ExpList, 1), 
    createExpList(ExpList),
    pstrike(First, Mult, Elems, Max, ExpList, Options, Label, Time),
    writeResult(Label, Time).



% - Run the game with pre-defined labeling options
pstrike(First, Mult, Elems, Max, ExpList, Options, Numbers, ExecutionTime):-
    NumElems is Elems + 1,
    length(Numbers, NumElems),
    domain(Numbers, 1, Max),
    element(1, Numbers, First), 
    element(NumElems, Numbers, First),
    addConstraints(Numbers, Mult, ExpList, [], Exponents),
    append(Exponents, Numbers, Label),
    statistics(runtime, [T0 | _]),
    labeling(Options, Label),
    statistics(runtime, [T1 | _]),
    ExecutionTime is T1 - T0.


