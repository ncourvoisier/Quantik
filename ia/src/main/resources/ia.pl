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


% This function play a random move in the grid with the available pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns available to play
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

% This function play a random move in the grid with the available pawn and return the new list of available pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns available to play
% NvPionRestant : The new list of available pawn
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


% This function play a random move in the grid with the available pawn and return the new list of available pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : return the number of the line played
% Colonne : return the number of the column played
% Pion : return the pawn played
% PionRestant : The pawns available to play
% NvPionRestant : The new list of available pawn
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


%%%%%%%%%%%%%%%%%%%% Heuristique %%%%%%%%%%%%%%%%%%%%

poidsLigne([], 0):-
    !.
poidsLigne([L0|Ligne], Poids):-
    L0 \= 0,
    poidsLigne(Ligne, P),
    Poids is P + 1,!.
poidsLigne([_|Ligne], Poids):-
    poidsLigne(Ligne, Poids).
poidsLigne(Grid, LigneNb, Poids):-
    nth0(LigneNb,Grid,Ligne),
    poidsLigne(Ligne, Poids).

poidsColonne([], _, 0):-
    !.
poidsColonne([Ligne|Grid], ColonneNb, Poids):-
    nth0(ColonneNb, Ligne, Val),
    Val \= 0,
    poidsColonne(Grid, ColonneNb, P),
    Poids is P + 1,!.
poidsColonne([_|Grid], ColonneNb, Poids):-
    poidsColonne(Grid, ColonneNb, Poids),!.

% /!\ fonction peu optimisée /!\
differentZero(0, 0):-!.
differentZero(_,1).
comportePion(_, _, _, 0).
poidsCarree(Grid, ColonneNb, LigneNb, Poids):-
    mod2Inf(ColonneNb, X),
    mod2Inf(LigneNb, Y),
    retournePionDansCase(Grid, X, Y, V1),
    retournePionDansCase(Grid, X1, Y, V2),
    X1 is X + 1,
    retournePionDansCase(Grid, X, Y1, V3),
    Y1 is Y + 1,
    retournePionDansCase(Grid, X1, Y1, V4),
    differentZero(V1,P1),
    differentZero(V2,P2),
    differentZero(V3,P3),
    differentZero(V4,P4),
    Poids is P1 + P2 + P3 + P4,!.

indexCarreeE(0, 0, 0).
indexCarreeE(0, 2, 1).
indexCarreeE(2, 0, 2).
indexCarreeE(2, 2, 3).
indexCarree(L,C,Ind):-
    mod2Inf(L,LCar),
    mod2Inf(C,CCar),
    indexCarreeE(LCar,CCar,Ind).

poidsMappingApplyLigne([], _, _, _):-!.
poidsMappingApplyLigne([Poids|Ligne], [PoidsL,PoidsCo,PoidsCa], CurrL, CurrC):-
    nth0(CurrL, PoidsL, X0),
    nth0(CurrC, PoidsCo, X1),
    indexCarree(CurrC, CurrL, IndC),
    nth0(IndC, PoidsCa, X2),
    max_list([X0,X1,X2], Poids),
    NextCurrC is CurrC + 1,
    poidsMappingApplyLigne(Ligne, [PoidsL,PoidsCo,PoidsCa], CurrL, NextCurrC).

poidsMappingApply([], _, _, _):-!.
poidsMappingApply([Ligne|PoidsMap], Poids, CurrL, CurrC):-
    poidsMappingApplyLigne(Ligne, Poids, CurrL, CurrC),
    NextCurrL is CurrL + 1,
    poidsMappingApply(PoidsMap, Poids, NextCurrL, CurrC).

poidsMapping(Grid, PoidsMap):-
    poidsLigne(Grid, 0, L0),
    poidsLigne(Grid, 1, L1),
    poidsLigne(Grid, 2, L2),
    poidsLigne(Grid, 3, L3),
    poidsColonne(Grid, 0, Co0),
    poidsColonne(Grid, 1, Co1),
    poidsColonne(Grid, 2, Co2),
    poidsColonne(Grid, 3, Co3),
    poidsCarree(Grid, 0, 0, Ca0),
    poidsCarree(Grid, 2, 0, Ca1),
    poidsCarree(Grid, 0, 2, Ca2),
    poidsCarree(Grid, 2, 2, Ca3),
    Poids = [[L0,L1,L2,L3],[Co0,Co1,Co2,Co3],[Ca0,Ca1,Ca2,Ca3]],
    PoidsMap = [[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],
    poidsMappingApply(PoidsMap, Poids, 0, 0),!.

apparieCase(0, [ListeP0,ListeP1,ListeP2,ListeP3], [[[CurrC,CurrL]|ListeP0],ListeP1,ListeP2,ListeP3], CurrL, CurrC).
apparieCase(1, [ListeP0,ListeP1,ListeP2,ListeP3], [ListeP0,[[CurrC,CurrL]|ListeP1],ListeP2,ListeP3], CurrL, CurrC).
apparieCase(2, [ListeP0,ListeP1,ListeP2,ListeP3], [ListeP0,ListeP1,[[CurrC,CurrL]|ListeP2],ListeP3], CurrL, CurrC).
apparieCase(3, [ListeP0,ListeP1,ListeP2,ListeP3], [ListeP0,ListeP1,ListeP2,[[CurrC,CurrL]|ListeP3]], CurrL, CurrC).

prioriteLigne([], PrioListes, PrioListes, _, _):-!.
prioriteLigne([Case|Ligne], PrioListes, NvPrioListes, CurrL, CurrC):-
    apparieCase(Case, PrioListes, NvPrioListesApresAppariement, CurrL, CurrC),
    NextCurrC is CurrC + 1,
    prioriteLigne(Ligne, NvPrioListesApresAppariement, NvPrioListes, CurrL, NextCurrC).

prioriteListe([], PrioListes, PrioListes, _, _):-!.
prioriteListe([Ligne|PoidsMap], PrioListes, NvPrioListes, CurrL, CurrC):-
    prioriteLigne(Ligne, PrioListes, NvPrioListesApresLigne, CurrL, CurrC),
    NextCurrL is CurrL + 1,
    prioriteListe(PoidsMap, NvPrioListesApresLigne, NvPrioListes, NextCurrL, CurrC).

flatten_level2([], Flat, Flat).
flatten_level2([Elem|Liste], Flat, NvFlat):-
    append(Flat, [Elem], NvFlatPlusElem),
    flatten_level2(Liste, NvFlatPlusElem, NvFlat).

flatten_level1([], Flat, Flat):-!.
flatten_level1([Liste|Q], Flat, NvFlat):-
    flatten_level2(Liste, Flat, NvFlatApr2),
    flatten_level1(Q, NvFlatApr2, NvFlat).

prioriteListe(Grid, Liste):-
    poidsMapping(Grid, PoidsMap),
    prioriteListe(PoidsMap, [[],[],[],[]], [ListeP0, ListeP1, ListeP2, ListeP3], 0, 0),
    flatten_level1([ListeP3,ListeP1,ListeP0,ListeP2], [], Liste).


verifAll(Grid,L,C,P) :-
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
        write("true"),true
    ;
        write("false"),false
    ),
    !.


pionRandom(PionRestant,P) :-
    length(PionRestant,S),
    random(0,S,P1),
    nth0(P1,PionRestant,P).

jouerPosition(Grid,[],_,_,_,_) :-
    !.
jouerPosition(Grid,[T|Res], PionRestant, L,C,P) :-
    nth0(0,T,L1),
    nth0(1,T,C1),
    write(L1),
    writeln(C1),
    pionRandom(PionResant,P1),
    verifAll(Grid,L1,C1,P1),
    jouerPosition(Grid,Res,PionRestant,L,C,P).

jouerCoupHeuristique(Grid, PionRestant, L,C,P) :-
    prioriteListe(Grid, Res),
    jouerPosition(Grid,Res,PionRestant,L,C,P).




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

    test('poidsLigne-0', [true]):-
        poidsLigne([[0,0,2,0],[3,1,0,0],[0,0,0,0],[4,0,1,2]], 0, 1).
    test('poidsLigne-1', [true]):-
        poidsLigne([[0,0,2,0],[3,1,0,0],[0,0,0,0],[4,0,1,2]], 1, 2).
    test('poidsLigne-2', [true]):-
        poidsLigne([[0,0,2,0],[3,1,0,0],[0,0,0,0],[4,0,1,2]], 2, 0).
    test('poidsLigne-3', [true]):-
        poidsLigne([[0,0,2,0],[3,1,0,0],[0,0,0,0],[4,0,1,2]], 3, 3).
    test('poidsLigne-f', [fail]):-
        poidsLigne([[0,0,0,0],[3,1,0,0],[0,0,0,0],[4,0,1,2]], 0, 1).

    test('poidsColonne-0', [true]):-
        poidsColonne([[0,0,2,0],[3,0,3,2],[0,0,0,1],[0,0,0,2]], 0, 1).
    test('poidsColonne-1', [true]):-
        poidsColonne([[0,0,2,0],[3,0,3,2],[0,0,0,1],[0,0,0,2]], 1, 0).
    test('poidsColonne-2', [true]):-
        poidsColonne([[0,0,2,0],[3,0,3,2],[0,0,0,1],[0,0,0,2]], 2, 2).
    test('poidsColonne-3', [true]):-
        poidsColonne([[0,0,2,0],[3,0,3,2],[0,0,0,1],[0,0,0,2]], 3, 3).
    test('poidsColonne-f', [fail]):-
        poidsColonne([[0,0,2,0],[3,0,3,2],[0,0,0,1],[0,0,0,0]], 3, 3).

    test('poidsCarree-0', [true]):-
        poidsCarree([[0,0,2,0],[0,0,3,2],[1,0,0,1],[0,0,0,2]], 0, 0, 0).
    test('poidsCarree-1', [true]):-
        poidsCarree([[0,0,2,0],[0,0,3,2],[1,0,0,1],[0,0,0,2]], 0, 2, 3).
    test('poidsCarree-2', [true]):-
        poidsCarree([[0,0,2,0],[0,0,3,2],[1,0,0,1],[0,0,0,2]], 2, 0, 1).
    test('poidsCarree-3', [true]):-
        poidsCarree([[0,0,2,0],[0,0,3,2],[1,0,0,1],[0,0,0,2]], 2, 2, 2).
    test('poidsCarree-f', [fail]):-
        poidsCarree([[0,0,2,0],[0,0,3,2],[1,2,0,1],[0,0,0,2]], 2, 0, 1).

    test('poidsMapping-Empty', [true]):-
        poidsMapping([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]).
    test('poidsMapping-1Corner', [true]):-
        poidsMapping([[a,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], [[1,1,1,1],[1,1,0,0],[1,0,0,0],[1,0,0,0]]).
    test('poidsMapping-2SidedCornersTop', [true]):-
        poidsMapping([[a,0,0,b],[0,0,0,0],[0,0,0,0],[0,0,0,0]], [[2,2,2,2],[1,1,1,1],[1,0,0,1],[1,0,0,1]]).
    test('poidsMapping-2SidedCornersBottom', [true]):-
        poidsMapping([[0,0,0,0],[0,0,0,0],[0,0,0,0],[a,0,0,b]], [[1,0,0,1],[1,0,0,1],[1,1,1,1],[2,2,2,2]]).
    test('poidsMapping-2SidedCornersLeft', [true]):-
        poidsMapping([[a,0,0,0],[0,0,0,0],[0,0,0,0],[b,0,0,0]], [[2,1,1,1],[2,1,0,0],[2,1,0,0],[2,1,1,1]]).
    test('poidsMapping-2SidedCornersRight', [true]):-
        poidsMapping([[0,0,0,a],[0,0,0,0],[0,0,0,0],[0,0,0,b]], [[1,1,1,2],[0,0,1,2],[0,0,1,2],[1,1,1,2]]).
    test('poidsMapping-4Corners', [true]):-
        poidsMapping([[a,0,0,b],[0,0,0,0],[0,0,0,0],[c,0,0,d]], [[2,2,2,2],[2,1,1,2],[2,1,1,2],[2,2,2,2]]).
    test('poidsMapping-Diagonal', [true]):-
        poidsMapping([[a,0,0,0],[0,b,0,0],[0,0,c,0],[0,0,0,d]], [[2,2,1,1],[2,2,1,1],[1,1,2,2],[1,1,2,2]]).
    test('poidsMapping-2TopLeftHorizontal', [true]):-
        poidsMapping([[a,b,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]], [[2,2,2,2],[2,2,0,0],[1,1,0,0],[1,1,0,0]]).
    test('poidsMapping-3BottomRightAngle', [true]):-
        poidsMapping([[0,0,0,0],[0,0,0,0],[0,0,0,a],[0,0,b,c]], [[0,0,1,2],[0,0,1,2],[1,1,3,3],[2,2,3,3]]).
    test('poidsMapping-6BottomLeftTopRightAngles', [true]):-
        poidsMapping([[0,0,a,b],[0,0,0,b],[d,0,0,0],[e,f,0,0]], [[2,2,3,3],[2,1,3,3],[3,3,1,2],[3,3,2,2]]).
    test('poidsMapping-FullBottomExceptBottomRight', [true]):-
        poidsMapping([[0,0,0,0],[0,0,0,0],[0,0,0,0],[a,b,c,0]], [[1,1,1,0],[1,1,1,0],[2,2,1,1],[3,3,3,3]]).
    test('poidsMapping-FullLeftExceptTopLeft', [true]):-
        poidsMapping([[0,0,0,0],[a,0,0,0],[b,0,0,0],[c,0,0,0]], [[3,1,0,0],[3,1,1,1],[3,2,1,1],[3,2,1,1]]).
    test('poidsMapping-1MiddleTopRight', [true]):-
        poidsMapping([[0,0,0,0],[0,0,a,0],[0,0,0,0],[0,0,0,0]], [[0,0,1,1],[1,1,1,1],[0,0,1,0],[0,0,1,0]]).
    test('poidsMapping-1MiddleTopRight1MiddleBottomLeft', [true]):-
        poidsMapping([[0,0,0,0],[0,0,a,0],[0,b,0,0],[0,0,0,0]], [[0,1,1,1],[1,1,1,1],[1,1,1,1],[1,1,1,0]]).
    test('poidsMapping-FullMiddle', [true]):-
        poidsMapping([[0,0,0,0],[0,a,b,0],[0,c,d,0],[0,0,0,0]], [[1,2,2,1],[2,2,2,2],[2,2,2,2],[1,2,2,1]]).
    test('poidsMapping-PrettyBadSituation', [true]):-
        poidsMapping([[0,a,b,0],[c,0,0,d],[e,0,0,f],[0,g,h,0]], [[2,2,2,2],[2,2,2,2],[2,2,2,2],[2,2,2,2]]).
    test('poidsMapping-5WinningSpots', [true]):-
        poidsMapping([[a,b,c,0],[0,d,e,f],[g,h,i,0],[j,0,0,k]], [[3,3,3,3],[3,3,3,3],[3,3,3,3],[3,3,3,2]]).


:-end_tests(chp0).
