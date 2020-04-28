% prolog ia

% La bilbliothque de test unitaire
:-use_module(library(plunit)).

% La bibliotheque de CLP
:-use_module(library(clpfd)).


pion(cylindre, pave, sphere, tetraedre).
pionN(cn, pn, sn, tn).
pionB(cb, pb, sb, tb).

%PT is [cn,pn,sn,tn].


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

jouerCoupRandom(L, C, P) :-
    random(0,4,C),
    random(0,4,L),
    random(0,4,P).

jouerCoupRandomSurCaseVide(H, L,C,P) :-
    random(0,4,L),
    random(0,4,C),
    random(0,4,P),
    COUP = [L,C,P],
    \+member(COUP, H).


% This function check the value of the case
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : the coordinate in line
% Colonne : the coordinate in column
% Val : the value return in case
retournePionDansCase(Grid, Ligne, Colonne, Val) :-
    nth0(Ligne,Grid,L),
    nth0(Colonne,L,Val),write(Val).

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

%Ca marche pas encore, je check demain
verifCarre(Grid, Ligne, Colonne, Pion) :-
    Ligne < 2 -> Colonne < 2 -> write("00"),

    Ligne < 2 -> Colonne > 2 -> write("02"),

    Ligne > 2 -> Colonne < 2 -> write("20"),

    Ligne > 2 -> Colonne > 2 -> write("22").


    %Colonne < 2 ,
    %write("00 11"),!;
    %write("02 13"),!
    %;
    %Colonne < 2 ,
    %write("20 13"),!;
    %write("22 33"),!.


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

    test('verifCarre1', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],a).
    test('verifCarre2', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],b).
    test('verifCarre3', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],c).
    test('verifCarre4', [true]) :-
        verifCarre1([[a,b,0,0],[c,d,0,0],[0,0,0,0],[0,0,0,0]],d).

:-end_tests(chp0).




