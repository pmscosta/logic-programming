
:- consult('gamelogic.pl').
:-use_module(library(timeout)).


writeResult(Label, Time):-
    write('Execution time: '), write(Time), write(' ms.'), nl,
    write('Result: '), write(Label), nl.

writeChosen(F, M, E, O):-
    format('First Element: ~w ~t Multiplier: ~w ~t Number of Elements: ~w~n Options: ~w ~n', [F, M, E, O]).

/**
 * solve
 * 
 *  Solves a random valid instance of the game
 * 
 * */
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


/**
 * solve(+First, +Mult, -Elems, +Options)
 * 
 *  Solves a specified instance of the game with specific labelling options
 * 
 *  @param First - First number
 *  @param Mult - Multiplier
 *  @param Elems - Number of elements of the puzzle board
 *  @param Options - Labbeling options
 * 
 * 
 * ---------------------PEDRO VICIADO EM SOCIAL MEDIA --------------------------
 * Correto? Elems
 * */
solve(First, Mult, Elems, Options):-
    number(Mult), !, number(First), !, number(Elems), !,
    maxValue(First, Mult, Elems, Max),
    number_of_digits(Max, MaxDigits),
    length(ExpList, MaxDigits),
    element(1, ExpList, 1), 
    createExpList(ExpList),
    pstrike(First, Mult, Elems, Max, ExpList, Options, Label, Time),
    writeResult(Label, Time).



/**
 * pstrike(+First, +Mult, +Elems, +Max, +ExpList, +Options, -Numbers, -ExecutionTime)
 * 
 *  Runs the puzzle solver for a specified instance of the game with specific labelling options
 * 
 *  @param First - First number
 *  @param Mult - Multiplier
 *  @param Elems - Number of elements of the puzzle board
 *  @param Max - Maximum number the puzzle numbers can take
 *  @param ExpList - Valid exponents list
 *  @param Options - Labbeling options
 *  @param Numbers - Puzzle board representation
 *  @param ExecutionTime - Time of execution of the solver
 * 
 * 
 * ---------------------PEDRO VICIADO EM SOCIAL MEDIA --------------------------
 * Correto?
 * */
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


