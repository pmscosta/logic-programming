printMainMenu:-
    write('***********************'), nl,
    write('*     -Neutreeko-     *'), nl , 
    write('***********************'), nl,
    write('*   Choose an option  *'), nl, 
    write('*       1-Play        *'), nl,
    write('*       2-Rules       *'), nl,
    write('*       3-Exit        *'), nl,
    write('***********************'), nl.

mainMenu:-
    printMainMenu, 
    read(X), waitForKeyPress, 
     nl,
    (
        X = 1, playMenu;
        X = 2,  mainMenu; 
        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        mainMenu
    ).


printGamePlayMenu:-
        write('***********************'), nl,
        write('*     -Neutreeko-     *'), nl , 
        write('***********************'), nl,
        write('*   Choose an option  *'), nl, 
        write('*   1-Human vs Human  *'), nl,
        write('*    2-Human vs Bot   *'), nl,
        write('*     3-Bot vs Bot    *'), nl,
        write('*       4-Back        *'), nl,
        write('***********************'), nl.



playMenu:-
    printGamePlayMenu, 
    read(X), waitForKeyPress, 
    nl, 
    (

        X = 1, startPvPGame; 
        X = 2, botMenu(2); 
        X = 3, botMenu(3);
        X = 4, mainMenu;
        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        playMenu
    ).

printBotMenu:-
    write('***********************'), nl,
    write('*     -Neutreeko-     *'), nl , 
    write('***********************'), nl,
    write('*   Choose an option  *'), nl, 
    write('*     1-Random Bot    *'), nl,
    write('*     2-Greedy Bot    *'), nl,
    write('*    3-Mini-Max Bot   *'), nl,
    write('*        4-Back       *'), nl,
    write('***********************'), nl.

botMenu(Mode):-
    printBotMenu, 
    read(X), waitForKeyPress, 
    nl, 
    (
        Mode = 2, 
        (
            pickFirstPlayer(First),
            (
                X = 1, startPvBGame(X, First);
                X = 2, startPvBGame(X, First); 
                X = 3, startPvBGame(X, First);
                X = 4, playMenu
            )
        )
        ;
        Mode = 3,
        (
                X = 1, startBvBGame(X);
                X = 2, startBvBGame(X); 
                X = 3, startBvBGame(X);
                X = 4, playMenu
        ),
        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        botMenu(Mode)
    ).


pickFirstPlayer(X):-
    printFirstPlayerMenu,
    read(Temp), waitForKeyPress, 
    X is Temp - 1, 
    nl,
    (
        X = 3, playMenu;
        \+ between(1, 3, Temp), 
        write('Invalid Choice! Press any key to try1 again'), nl,
        waitForKeyPress, 
        pickFirstPlayer(Nx);
        true     
    ).

/*    (
        between(1, 2, Temp), X = Temp
        ;
        Temp = 3, playMenu
        ;
        write('Invalid Choice! Press any key to try1 again'), nl,
        waitForKeyPress, 
        pickFirstPlayer(Nx)
    ).
*/


printFirstPlayerMenu:-
        write('***********************'), nl,
        write('*     -Neutreeko-     *'), nl , 
        write('***********************'), nl,
        write('*   Choose an option  *'), nl, 
        write('*      1-Bot First    *'), nl,
        write('*     2-Human First   *'), nl,
        write('*       3-Back        *'), nl,
        write('***********************'), nl.




    