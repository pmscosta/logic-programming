printMainMenu:-
    write('***********************'), nl,
    write('*     -Neutreeko-     *'), nl , 
    write('***********************'), nl,
    write('*   Chose an option   *'), nl, 
    write('*       1-Play        *'), nl,
    write('*       2-Rules       *'), nl,
    write('*       3-Exit        *'), nl,
    write('***********************'), nl.

mainMenu:-
    printMainMenu, 
    read(X), waitForKeyPress, 
     nl,
    (
        X = 1 -> startGame, mainMenu;
        X = 2 -> mainMenu, mainMenu;
        X = 3;

        write('Invalid Choice! Press any key to try again'), nl,
        waitForKeyPress, 
        mainMenu
    ).