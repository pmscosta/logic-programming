:-use_module('powerstrike.pl').

invalid:-
    write('Invalid Choice! Press Enter to try again'), nl, discard_new_line, fail.

return:-
    write('Press any key to go back!'), nl,discard_new_line.

cls :- write('\e[H\e[2J').

discard_new_line:-
    get_code(_).


printMainMenu:-
    write('*************************'), nl,
    write('*     -Powerstrike-     *'), nl , 
    write('*************************'), nl,
    write('*    Choose an option   *'), nl, 
    write('*      1-Example 1      *'), nl,
    write('*      2-Example 2      *'), nl,
    write('*      3-Example 3      *'), nl,
    write('*      4-Random Run     *'), nl,
    write('*        5-Exit         *'), nl,
    write('*************************'), nl.

start:-
    cls,
    printMainMenu, 
    repeat,
    catch(read(X), _, fail),
    number(X),
    discard_new_line,
    nl,
    (
        X = 1, !, solve(6, 2, 5, [max_regret,bisect,up]), return, start;
        X = 2, !, solve(11, 3, 11, [max_regret,bisect,up]), return, start;
        X = 3, !, solve(41, 7, 8, [max_regret,bisect,down]), return, start;
        X = 4, !, solve, return, start;
        X = 5, true;
        invalid
    ).



