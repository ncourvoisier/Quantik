% prolog ia

% La bilbliothque de test unitaire
:-use_module(library(plunit)).

% La bibliotheque de CLP
:-use_module(library(clpfd)).


pion(cylindre, pave, sphere, tetraedre).
pionN(cn, pn, sn, tn).
pionB(cb, pb, sb, tb).


% This function return a random integer in born
%
% L : The min for the draw
% U : The max for the draw
% R : return the integer
random(L, U, R) :-
    integer(L), integer(U),
    !,
    R is L+random(U-L).
random(L, U, R) :-
    number(L), number(U),
    !,
    R is L+((U-L)*random_float).
random(L, U, _) :-
    must_be(number, L),
    must_be(number, U).


% This function play a random move in the grid
%
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the number of the pawn played
jouerCoupRandom(Ligne, Colonne, Pion) :-
    random(0,4,Colonne),
    random(0,4,Ligne),
    random(0,4,Pion).


% This function play a random move in the grid
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns aviable to play
jouerCoupRandomSurCaseVide(Grid,Ligne,Colonne,Pion,PionRestant) :-
    random(0,4,L),
    random(0,4,C),
    random(0,4,P),
    retournePionDansCase(Grid,L,C,Val),
    Val == 0,
        Ligne = L,
        Colonne = C,
        Pion = P,!;
        jouerCoupRandomSurCaseVide(Grid,Ligne,Colonne,Pion,PionRestant).



jouerCoupRandomSurCaseVideT(Grid,Ligne,Colonne,Pion,PionRestant) :-
    random(0,4,L),
    random(0,4,C),
    length(PionRestant,S),
    S1 is S - 1,
    random(0,S1,P1),
    write(P1),
    nth0(P1,PionRestant,Pion),
    write(" Pion = "),write(Pion),write("\n"),
    retournePionDansCase(Grid,L,C,Val),
    writeln(Val),
    writeln(L),
    writeln(C),
    Val == 0,
        Ligne = L,
        Colonne = C,
        write(Pion),!;
        write("ici"),
        jouerCoupRandomSurCaseVide(Grid,Ligne,Colonne,Pion,PionRestant).












% This function check the value of the case
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : the coordinate in line
% Colonne : the coordinate in column
% Val : the value return in case
retournePionDansCase(Grid, Ligne, Colonne, Val) :-
    nth0(Ligne,Grid,L),
    nth0(Colonne,L,Val).

% This function check if the line contain a pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : the line to check
% Pion : the pawn to check if is in the line
verifLigne(Grid, Ligne, Pion) :-
    nth0(Ligne,Grid,L),
    nth0(_,L,Pion),!.

% This function check if the column contain a pawn
%
% [Ligne|Grid] : the grid of Quantik game with the preceding move of player
% Colonne : the column to check
% Pion : the pawn to check if is in the column
verifColonne([],_,_) :-
    false,!.
verifColonne([Ligne|Grid], Colonne, Pion) :-
    nth0(Colonne,Ligne, Pion),!;
    verifColonne(Grid, Colonne, Pion).


% This function check if the square 1 contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Pion : the pawn to check if is in the square
verifCarre1(Grid, Pion) :-
    retournePionDansCase(Grid,0,0,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,0,1,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,1,0,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,1,1,Val),
    Val == Pion,!;
    false.

% This function check if the square 2 contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Pion : the pawn to check if is in the square
verifCarre2(Grid, Pion) :-
    retournePionDansCase(Grid,0,2,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,0,3,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,1,2,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,1,3,Val),
    Val == Pion,!;
    false.

% This function check if the square 3 contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Pion : the pawn to check if is in the square
verifCarre3(Grid, Pion) :-
    retournePionDansCase(Grid,2,0,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,2,1,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,3,0,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,3,1,Val),
    Val == Pion,!;
    false.

% This function check if the square 4 contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Pion : the pawn to check if is in the square
verifCarre4(Grid, Pion) :-
    retournePionDansCase(Grid,2,2,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,2,3,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,3,2,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,3,3,Val),
    Val == Pion,!;
    false.

% This function check if the superior rectangle contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Colonne : the column to check
% Pion : the pawn to check if is in the square with the coordinate line and column
verifRectangleSup(Grid, Colonne, Pion) :-
    Colonne < 2,
        verifCarre1(Grid,Pion),!;
        verifCarre2(Grid,Pion),!.

% This function check if the inferior rectangle contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Colonne : the column to check
% Pion : the pawn to check if is in the square with the coordinate line and column
verifRectangleInf(Grid, Colonne, Pion) :-
    Colonne < 2,
        verifCarre3(Grid,Pion),!;
        verifCarre4(Grid,Pion),!.

% This function check if the square determinate with line and column contain a pawn
%
% Grid : the grid of Quantik game with the preceding move of player
% Ligne : the line position of the new move
% Colonne : the column position of the new move
% Pion : the pawn to check if is in the square with the coordinate line and column
verifCarre(Grid, Ligne, Colonne, Pion) :-
    Ligne < 2,
    verifRectangleSup(Grid,Colonne,Pion),!;
    verifRectangleInf(Grid,Colonne,Pion),!.



% Les tests unitaires :
:-begin_tests(chp0).

    test('verifLigne1', [true]) :-
        verifLigne([[0,0,0,0],[0,0,0,0],[0,cn,0,0],[0,0,0,0]],2,cn).
    test('verifLigne2', [fail]) :-
        verifLigne([[0,0,0,0],[0,0,0,0],[0,cn,0,0],[0,0,0,0]],2,pn).
    test('verifLigne3', [true]) :-
        verifLigne([[0,0,0,0],[0,cn,0,0],[0,cn,0,0],[0,0,0,0]],2,cn).
    test('verifLigne4', [fail]) :-
        verifLigne([[0,0,0,0],[0,cn,0,0],[0,0,0,0],[0,0,0,0]],2,cn).
    test('verifLigne5', [fail]) :-
        verifLigne([[cb,0,0,0],[0,cn,0,0],[0,0,0,0],[0,0,0,0]],0,cn).

    test('verifColonne1', [true]) :-
        verifColonne([[0,0,0,0],[0,0,0,0],[0,cn,0,0],[0,0,0,0]],1,cn).
    test('verifColonne2', [fail]) :-
        verifColonne([[0,0,0,0],[0,0,0,0],[0,cn,0,0],[0,0,0,0]],1,pn).
    test('verifColonne3', [true]) :-
        verifColonne([[0,0,0,0],[0,cn,0,0],[0,cn,0,0],[0,0,0,0]],1,cn).
    test('verifColonne4', [fail]) :-
        verifColonne([[0,0,0,0],[0,cn,0,0],[0,0,0,0],[0,0,0,0]],0,cn).
    test('verifColonne5', [fail]) :-
        verifColonne([[cb,0,0,0],[0,cn,0,0],[0,cb,0,0],[0,0,0,cb]],0,cn).

    test('verifCarre11', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],a).
    test('verifCarre12', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],b).
    test('verifCarre13', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],c).
    test('verifCarre14', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],d).
    test('verifCarre15', [fail]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],0).

    test('verifCarre21', [true]) :-
        verifCarre2([[0,0,a,b],[0,0,c,d],[0,0,0,0],[0,0,0,0]],a).
    test('verifCarre22', [true]) :-
        verifCarre2([[0,0,a,b],[0,0,c,d],[0,0,0,0],[0,0,0,0]],b).
    test('verifCarre23', [true]) :-
        verifCarre2([[0,0,a,b],[0,0,c,d],[0,0,0,0],[0,0,0,0]],c).
    test('verifCarre24', [true]) :-
        verifCarre2([[0,0,a,b],[0,0,c,d],[0,0,0,0],[0,0,0,0]],d).
    test('verifCarre25', [fail]) :-
        verifCarre2([[0,0,a,b],[0,0,c,d],[0,0,0,0],[0,0,0,0]],0).

    test('verifCarre31', [true]) :-
        verifCarre3([[0,0,0,0],[0,0,0,0],[a,b,0,0],[c,d,0,0]],a).
    test('verifCarre32', [true]) :-
        verifCarre3([[0,0,0,0],[0,0,0,0],[a,b,0,0],[c,d,0,0]],b).
    test('verifCarre33', [true]) :-
        verifCarre3([[0,0,0,0],[0,0,0,0],[a,b,0,0],[c,d,0,0]],c).
    test('verifCarre34', [true]) :-
        verifCarre3([[0,0,0,0],[0,0,0,0],[a,b,0,0],[c,d,0,0]],d).
    test('verifCarre35', [fail]) :-
        verifCarre3([[0,0,0,0],[0,0,0,0],[a,b,0,0],[c,d,0,0]],0).

    test('verifCarre41', [true]) :-
        verifCarre4([[0,0,0,0],[0,0,0,0],[0,0,a,b],[0,0,c,d]],a).
    test('verifCarre42', [true]) :-
        verifCarre4([[0,0,0,0],[0,0,0,0],[0,0,a,b],[0,0,c,d]],b).
    test('verifCarre43', [true]) :-
        verifCarre4([[0,0,0,0],[0,0,0,0],[0,0,a,b],[0,0,c,d]],c).
    test('verifCarre44', [true]) :-
        verifCarre4([[0,0,0,0],[0,0,0,0],[0,0,a,b],[0,0,c,d]],d).
    test('verifCarre45', [fail]) :-
        verifCarre4([[0,0,0,0],[0,0,0,0],[0,0,a,b],[0,0,c,d]],0).

:-end_tests(chp0).




