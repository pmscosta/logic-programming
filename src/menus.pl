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
        X = 2, startPvBGame; 
        X = 3, botMenu;
        X = 4, mainMenu;
        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        mainMenu
    ).

printBotMenu:-
    write('***********************'), nl,
    write('*     -Neutreeko-     *'), nl , 
    write('***********************'), nl,
    write('*   Choose an option  *'), nl, 
    write('*     1-Random Bot    *'), nl,
    write('*     2-Greedy Bot    *'), nl,
    write('*        3-Back       *'), nl,
    write('***********************'), nl.

botMenu:-
    printBotMenu, 
    read(X), waitForKeyPress, 
    nl, 
    (

        X = 1, startBvBGame(X);
        X = 2, startBvBGame(X); 
        X = 3, playMenu;
        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        mainMenu
    ).



    