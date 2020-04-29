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
jouerCoupRandomSurCaseVide(Grid,Ligne,Colonne,Pion) :-
    random(0,4,L),
    random(0,4,C),
    random(0,4,P),
    retournePionDansCase(Grid,L,C,Val),
    Val == 0,
        Ligne = L,
        Colonne = C,
        Pion = P,!;
        jouerCoupRandomSurCaseVide(Grid,Ligne,Colonne,Pion).


% This function play a random move in the grid with the aviable pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns aviable to play
jouerCoupRandomSurCaseVideAvecPionRestant(Grid,Ligne,Colonne,Pion,PionRestant) :-
    random(0,4,L),
    random(0,4,C),
    length(PionRestant,S),
    random(0,S,P1),
    nth0(P1,PionRestant,P),
    retournePionDansCase(Grid,L,C,Val),
    Val == 0,
        Ligne = L,
        Colonne = C,
        Pion = P,
        !;
        jouerCoupRandomSurCaseVideAvecPionRestant(Grid,Ligne,Colonne,Pion,PionRestant).

% This function play a random move in the grid with the aviable pawn and return the new list of aviable pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns aviable to play
% NvPionRestant : The new list of aviable pawn
jouerCoupRandomAvecPionDisponible(Grid,Ligne,Colonne,Pion,PionRestant, NvPionRestant) :-
    jouerCoupRandomSurCaseVideAvecPionRestant(Grid,Ligne,Colonne,Pion,PionRestant),
    select(Pion,PionRestant,NvPionRestant),!.

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

% This fonction returns the greatest multiplicator of 2 that is inferior or equal to Val
%
% Val : the input value
% Inf : the multiplicator of 2 that was found
mod2Inf(Val, Inf):-
    Int is Val // 2,
    Inf is Int * 2.

% This fonction checks if a pawn of the same type was already placed in this square
%
% Grid : the Quantik game grid
% Pion : the pawn we want to place
% Px : the x coordinate we want to place the pawn at
% Py : the y coordinate we want to place the pawn at
verifCarre(Grid, Pion, Px, Py):-
    mod2Inf(Px, CarX),
    mod2Inf(Py, CarY),
    verifCarreN(Grid, Pion, CarX, CarY).


% This fonction checks the existence of a given pawn type
% in the square located at the X,Y coordinates
%
% Grid : the Quantik game grid
% Pion : the pawn type we are seeking for
% X : the x coordinate of the square to search in
% Y : the y coordinate of the square to search in
verifCarreN(Grid, Pion, X, Y):-
    retournePionDansCase(Grid,X,Y,Val),
    Val == Pion,!;
    retournePionDansCase(Grid,X1,Y,Val),
    X1 is X + 1,
    Val == Pion,!;
    retournePionDansCase(Grid,X,Y1,Val),
    Y1 is Y + 1,
    Val == Pion,!;
    retournePionDansCase(Grid,X1,Y1,Val),
    X1 is X + 1,
    Y1 is Y + 1,
    Val == Pion,!;
    false.

% This fonctions checks the existence of a given pawn type in the 4 squares
%
% Grid : the Quantik game grid
% Pion : the pawn type we are seeking for
verifCarreAll(Grid, Pion):-
    verifCarreN(Grid, Pion, 0, 0),!;
    verifCarreN(Grid, Pion, 2, 0),!;
    verifCarreN(Grid, Pion, 0, 2),!;
    verifCarreN(Grid, Pion, 2, 2),!.


% This function play a random move in the grid with the aviable pawn and return the new list of aviable pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns aviable to play
% NvPionRestant : The new list of aviable pawn
jouerCoup(Grid,Ligne,Colonne,Pion,ListePion,NvListePion) :-
    jouerCoupRandomAvecPionDisponible(Grid,L,C,P,ListePion,NvListePion),
    Stop = 0,

    (verifColonne(Grid,L,P) ->
        Stop = 1
    ;
        write("")
    ),
    (verifColonne(Grid,C,P) ->
        Stop = 1
    ;
        write("")
    ),
    (verifCarre(Grid,P,L,C) ->
        Stop = 1
    ;
        write("")
    ),
    (Stop == 1 ->
        jouerCoup(Grid,Ligne,Colonne,Pion,ListePion,NvListePion)
    ;
        Ligne = L,
        Colonne = C,
        Pion = P
    ),
    !.




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

test('verifCarre1-1', [true]) :-
        verifCarre([[0,0,0,0],[0,a,0,0],[0,0,0,0],[0,0,0,0]], a, 0, 0).
    test('verifCarre1-2', [true]) :-
        verifCarre([[0,0,0,0],[0,a,0,0],[0,0,0,0],[0,0,0,0]], a, 1, 0).
    test('verifCarre1-3', [true]) :-
        verifCarre([[0,0,0,0],[0,a,0,0],[0,0,0,0],[0,0,0,0]], a, 0, 1).
    test('verifCarre1-4', [true]) :-
        verifCarre([[0,0,0,0],[0,a,0,0],[0,0,0,0],[0,0,0,0]], a, 1, 1).
    test('verifCarre1-f', [fail]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[a,0,0,0],[0,0,0,0]], a, 1, 1).

    test('verifCarre2-1', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 0, 2).
    test('verifCarre2-2', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 1, 2).
    test('verifCarre2-3', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 0, 3).
    test('verifCarre2-4', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 1, 3).
    test('verifCarre2-f', [fail]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[a,0,0,0],[0,0,0,0]], a, 1, 3).

    test('verifCarre3-1', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,a,0,0]], a, 2, 0).
    test('verifCarre3-2', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,a,0,0]], a, 3, 0).
    test('verifCarre3-3', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,a,0,0]], a, 2, 1).
    test('verifCarre3-4', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,a,0,0]], a, 3, 1).
    test('verifCarre3-f', [fail]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 3, 1).

    test('verifCarre4-1', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,a]], a, 2, 2).
    test('verifCarre4-2', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,a]], a, 3, 2).
    test('verifCarre4-3', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,a]], a, 2, 3).
    test('verifCarre4-4', [true]) :-
        verifCarre([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,a]], a, 3, 3).
    test('verifCarre4-f', [fail]) :-
        verifCarre([[0,0,0,0],[0,0,0,a],[0,0,0,0],[0,0,0,0]], a, 3, 3).

    test('jouerCoupRandomAvecPionDisponible11', [all([L,C] == [[2,3]])]) :-
        jouerCoupRandomAvecPionDisponible([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0],[cn,cn,cn,cn]], L, C, _, [cn,pn],_).
    test('jouerCoupRandomAvecPionDisponible12', [true(length(NvPion,1))]) :-
        jouerCoupRandomAvecPionDisponible([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0],[cn,cn,cn,cn]], _, _, _, [cn,pn],NvPion).

    test('jouerCoupRandomAvecPionDisponible12', [true(length(NvPion,0))]) :-
        jouerCoupRandomAvecPionDisponible([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0]], _, _, _, [pn],NvPion).
    test('jouerCoupRandomAvecPionDisponible22', [all([L,C,P] == [[3,3,pn]])]) :-
        jouerCoupRandomAvecPionDisponible([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0]], L, C, P, [pn],_).

    test('jouerCoup12', [all([L,C,P] == [[3,3,pn]])]) :-
        jouerCoup([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0]], L, C, P, [pn],_).
    test('jouerCoup12', [true(length(NvPion,0))]) :-
        jouerCoup([[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,cn],[cn,cn,cn,0]], _, _, _, [pn],NvPion).


:-end_tests(chp0).
