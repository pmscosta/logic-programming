:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(lists)).


number_of_digits(Number, Digits):-
        X = log(10, Number) + 1,
        Digits is floor(X).

createExpList(0, List, _, List).

createExpList(Digits, List, Value, Output):-
    NValue is Value * 10, 
    append(List, [Value], NList),
    NDigits is Digits - 1, 
    createExpList(NDigits, NList, NValue, Output).

createExpList(Digits, List):-
    createExpList(Digits, [], 1,List).

maxValue(First, Mult, Elems, Max):-
    Exp = Elems - 2, 
    Max is floor(First * ( Mult ** Exp)).


retractNumber(Number, MaxDigits, ExpList, Subtract, Exponent):-
    Exponent in 1 .. MaxDigits, 
    element(Exponent, ExpList, Exp),
    Subtract #= ( Number // (10 * Exp) ) * Exp + (Number mod Exp).

addConstrains([_], _, _, _,List, List).

addConstrains([A, B | C], Mult, MaxDigits, ExpList, ExpAcc, Exponents):-
    retractNumber(A, MaxDigits, ExpList, SubtractNumber, Exp),
    (B #= A * Mult) #\/ (A #>= 10 #/\ B #= SubtractNumber),
    append(ExpAcc, [Exp], NExpAcc),
    addConstrains([B | C], Mult, MaxDigits, ExpList, NExpAcc, Exponents).


pstrike(First, Mult, Elems, Max, MaxDigits, ExpList):-
    length(Numbers, Elems),
    domain(Numbers, 1, Max),
    element(1, Numbers, First), 
    element(Elems, Numbers, First),
    addConstrains(Numbers, Mult, MaxDigits, ExpList, [], Exponents),
    append(Exponents, Numbers, Label),
    statistics,
    labeling([max_regret, bisect], Label), 
    fd_statistics,
    statistics, 
    write(Numbers).

start:-
    Mult is 2, 
    First is 6, 
    Elems is 6,
    maxValue(First, Mult, Elems, Max),
    number_of_digits(Max, MaxDigits),
    createExpList(MaxDigits, ExpList),
    pstrike(First, Mult, Elems, Max, MaxDigits, ExpList). 