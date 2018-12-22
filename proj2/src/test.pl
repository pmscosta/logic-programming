:-consult('gamelogic.pl').
:-use_module(library(timeout)).





run_tests:-
    open('output.txt', write, FILE),
    small_test(FILE), 
    medium_test(FILE), 
    big_test(FILE),
    close(FILE).

run_best_tests:-
    open('best_output.txt', write, FILE),
    tests(FILE),
    close(FILE).

tests(FILE):-
    findall(Time, (best_option(Options),
                values(Vals),
                time_out(test(Vals, Options, _, Time),15000, Result), 
                number(Time), 
                writeRecord([Options, Time, Result], FILE)),
                _).


writeRecord([Options, Time, Result], FILE):-
    write(FILE, 'Options: '), 
    write(FILE, Options),
    write(FILE, ' Time: '), 
    write(FILE, Time), 
    write(FILE, ' Result: '), 
    write(FILE, Result), 
    nl(FILE).


small_test(FILE):-
    write(FILE, 'Small Test:'),
    nl(FILE),
    findall(Time, ( sel_var(X),
                    sel_value(Y), 
                    sel_order(Z),
                    Options = [X, Y, Z],
                    time_out(test([22, 3, 6], Options, _, Time),15000, Result), 
                    writeRecord([Options, Time, Result], FILE)),
                    _).

medium_test(FILE):-
    write(FILE, 'Medium Test:'),
    nl(FILE),
    findall(Time, ( sel_var(X),
                    sel_value(Y), 
                    sel_order(Z),
                    Options = [X, Y, Z],
                    time_out(test([17, 4, 11], Options, _, Time),400, Result), 
                    writeRecord([Options, Time, Result], FILE)),
                    _).

big_test(FILE):-
    write(FILE, 'Big Test:'),
    nl(FILE),
    findall(Time, ( sel_var(X),
                    sel_value(Y), 
                    sel_order(Z),
                    Options = [X, Y, Z],
                    time_out(test([41, 7, 8], Options, _, Time),100, Result), 
                    writeRecord([Options, Time, Result], FILE)),
                    _).


test(Values, Options, Label, Time):-
    Values = [First, Mult, Elems],
    maxValue(First, Mult, Elems, Max),
    number_of_digits(Max, MaxDigits),
    length(ExpList, MaxDigits),
    element(1, ExpList, 1), 
    createExpList(ExpList),
    run_single_test(First, Mult, Elems, Max, ExpList, Options, Label, Time).


run_single_test(First, Mult, Elems, Max, ExpList, Options, Numbers, ExecutionTime):-
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
    ExecutionTime is T1 - T0, !.