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

collectePions([], Trouve, Poids):-
    length(Trouve, Poids),!.
collectePions([P|_], Trouve, -1):-
    member(P, Trouve),!.
collectePions([P|Liste], Trouve, Poids):-
    \+ P is 0,
    append([P],Trouve,NvTrouve),
    collectePions(Liste, NvTrouve, Poids),!.
collectePions([_|Liste], Trouve, Poids):-
    collectePions(Liste, Trouve, Poids).

generePoids(Liste, Poids):-
    collectePions(Liste, [], Poids).

% Returns the number of pawns found on a line
%
% Grid : the Quantik game board
% LigneNb : the number of the line
% Poids : the returned number of pawns on the line
poidsLigne(Grid, LigneNb, Poids):-
    nth0(LigneNb,Grid,Ligne),
    generePoids(Ligne, Poids).

% Returns the number of pawns found on a column
%
% Grid : the Quantik game board
% ColonneNb : the number of the column
% Poids : the returned number of pawns on the column
poidsColonne([L0,L1,L2,L3], ColonneNb, Poids):-
    nth0(ColonneNb,L0,P0),
    nth0(ColonneNb,L1,P1),
    nth0(ColonneNb,L2,P2),
    nth0(ColonneNb,L3,P3),
    generePoids([P0,P1,P2,P3], Poids).

% Returns the number of pawns found in the square the given cell is in
%
% Grid : the Quantik game board
% LigneNb : the number of the line the cell belongs to
% ColonneNb : the number of the column the cell belongs to
% Poids : the returned number of pawns in the square
poidsCarree(Grid, ColonneNb, LigneNb, Poids):-
    mod2Inf(ColonneNb, X),
    mod2Inf(LigneNb, Y),
    retournePionDansCase(Grid, X, Y, V1),
    retournePionDansCase(Grid, X1, Y, V2),
    X1 is X + 1,
    retournePionDansCase(Grid, X, Y1, V3),
    Y1 is Y + 1,
    retournePionDansCase(Grid, X1, Y1, V4),
    generePoids([V1,V2,V3,V4], Poids),!.

% Gives a number between 0 and 3 to each square of the game
%
% L : The square origin line
% C : The square origin column
% Ind : The returned number for the square
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

% Takes a game board and generates a weights map, with a weight associated to each cell
% of the board. The weight of a cell tells how close we are to complete a line/column/square if we play in it.
%
% Grid : the Quantik game board
% PoidsMap : the returned weights map
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

apparieCase(-1, [ListePM1,ListeP0,ListeP1,ListeP2,ListeP3], [[[CurrL,CurrC]|ListePM1],ListeP0,ListeP1,ListeP2,ListeP3], CurrL, CurrC).
apparieCase(0, [ListePM1,ListeP0,ListeP1,ListeP2,ListeP3], [ListePM1,[[CurrL,CurrC]|ListeP0],ListeP1,ListeP2,ListeP3], CurrL, CurrC).
apparieCase(1, [ListePM1,ListeP0,ListeP1,ListeP2,ListeP3], [ListePM1,ListeP0,[[CurrL,CurrC]|ListeP1],ListeP2,ListeP3], CurrL, CurrC).
apparieCase(2, [ListePM1,ListeP0,ListeP1,ListeP2,ListeP3], [ListePM1,ListeP0,ListeP1,[[CurrL,CurrC]|ListeP2],ListeP3], CurrL, CurrC).
apparieCase(3, [ListePM1,ListeP0,ListeP1,ListeP2,ListeP3], [ListePM1,ListeP0,ListeP1,ListeP2,[[CurrL,CurrC]|ListeP3]], CurrL, CurrC).

prioriteLigne(_, [], PrioListes, PrioListes, _, _):-!.
prioriteLigne(Grid, [Case|Ligne], PrioListes, NvPrioListes, CurrL, CurrC):-
    retournePionDansCase(Grid, CurrL, CurrC, Pion),
    Pion is 0,
    apparieCase(Case, PrioListes, NvPrioListesApresAppariement, CurrL, CurrC),
    NextCurrC is CurrC + 1,
    prioriteLigne(Grid, Ligne, NvPrioListesApresAppariement, NvPrioListes, CurrL, NextCurrC),!.
prioriteLigne(Grid, [_|Ligne], PrioListes, NvPrioListes, CurrL, CurrC):-
    NextCurrC is CurrC + 1,
    prioriteLigne(Grid, Ligne, PrioListes, NvPrioListes, CurrL, NextCurrC),!.

prioriteGroupes(_, [], PrioListes, PrioListes, _, _):-!.
prioriteGroupes(Grid, [Ligne|PoidsMap], PrioListes, NvPrioListes, CurrL, CurrC):-
    prioriteLigne(Grid, Ligne, PrioListes, NvPrioListesApresLigne, CurrL, CurrC),
    NextCurrL is CurrL + 1,
    prioriteGroupes(Grid, PoidsMap, NvPrioListesApresLigne, NvPrioListes, NextCurrL, CurrC).

% Takes a board and generates a list of coordinates pairs, those are empty cells
% in the board given by priority order, the first cell in the list is the one
% that we have to try to play in first.
%
% Grid : the Quantik game board
% Liste : the returned coordinates pairs list
prioriteGroupes(Grid, Groupes):-
    poidsMapping(Grid, PoidsMap),
    prioriteGroupes(Grid, PoidsMap, [[],[],[],[],[]], Groupes, 0, 0).

% This function checks if the move is valid
%
% Grid : the Quantik grid
% L : the line to check
% C : the column to check
% P : the pawn to check
verifAll(Grid,L,C,P) :-
    write(L),
    write(C),
    writeln(P),
    Stop = 0,
    (verifLigne(Grid,L,P) ->
        write("faux ligne"),Stop = 1
    ;
        write("")
    ),
    (verifColonne(Grid,C,P) ->
        write("faux colonne"),Stop = 1
    ;
        write("")
    ),
    (verifCarre(Grid,P,L,C) ->
        write("faux carre"),Stop = 1
    ;
        write("")
    ),
    (Stop == 1 ->
        false
    ;
        true
    ),
    !.

% This function selects a pawn in avialable list of pawn
%
% PionRestant : the list of avialable pawn
% P : the pawn selected
pionRandom(PionRestant,P) :-
    length(PionRestant,S),
    random(0,S,P1),
    nth0(P1,PionRestant,P).

% This function calcules the next move
%
% Grid : the Quantik grid
% [T|Res] : The list of coordinate available order by priority
% PionRestant : the list of pawn avialable
% L : return the line of the move
% C : return the column of the mov
% P : return the pawn of the mov
jouerPosition(_,[],_,_,_,_) :-
    !.
jouerPosition(Grid,[T|Res], PionRestant, L,C,P) :-
    nth0(0,T,L1),
    nth0(1,T,C1),
    (testTousLesPions(Grid,PionRestant,L1,C1,L,C,P) ->
        true
    ;
        jouerPosition(Grid,Res,PionRestant,L,C,P)
    ),!.

% This functions checks all pawn avialable in PionRestant in coordinate L and C
%
% Grid : the Quantik grid
% [P1|PionRestant] : the list of pawn avialable
% L1 : The coordinate line checked
% C1 : The coordinate column checked
% L : return the line of the move
% C : return the column of the mov
% P : return the pawn of the mov
testTousLesPions(_,[],_,_,_,_,_) :-
    !.
testTousLesPions(Grid,[P1|PionRestant],L1,C1,L,C,P) :-
    (verifAll(Grid,L1,C1,P1) ->
        L = L1,
        C = C1,
        P = P1
        ,true
    ;
        testTousLesPions(Grid,PionRestant,L1,C1,L,C,P)
    ),!.

% This function realizes the next move for the game
%
% Grid : the Quantik grid
% PionRestant : the list of pawn avialable
% L : return the line of the move
% C : return the column of the mov
% P : return the pawn of the mov
% jouerCoupHeuristique(Grid, PionRestant, L,C,P) :-
%    prioriteListe(Grid, Res),
%    write(Res),
%    jouerPosition(Grid,Res,PionRestant,L,C,P).


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

    test('jouerCoupHeuristique1', [all([L,C] == [[3,3]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,_).
    test('jouerCoupHeuristique2', [all([L,C] == [[3,3]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,_).
    test('jouerCoupHeuristique3', [all([L,C] == [[3,3]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,_).

    test('jouerCoupHeuristique4', [all([L,C,P] == [[0,3,t]])]) :-
        jouerCoupHeuristique([[c,p,s,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique5', [all([L,C,P] == [[1,3,t]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[c,p,s,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique6', [all([L,C,P] == [[2,3,t]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,p,s,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique7', [all([L,C,P] == [[3,3,t]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[c,p,s,0]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique8', [all([L,C,P] == [[0,2,s]])]) :-
        jouerCoupHeuristique([[c,p,0,t],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique9', [all([L,C,P] == [[1,2,s]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[c,p,0,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique10', [all([L,C,P] == [[2,2,s]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,p,0,t],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique11', [all([L,C,P] == [[3,2,s]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[c,p,0,t]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique12', [all([L,C,P] == [[0,1,p]])]) :-
        jouerCoupHeuristique([[c,0,s,t],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique13', [all([L,C,P] == [[1,1,p]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[c,0,s,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique14', [all([L,C,P] == [[2,1,p]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,0,s,t],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique15', [all([L,C,P] == [[3,1,p]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[c,0,s,t]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique16', [all([L,C,P] == [[0,0,c]])]) :-
        jouerCoupHeuristique([[0,p,s,t],[0,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique17', [all([L,C,P] == [[1,0,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,p,s,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique18', [all([L,C,P] == [[2,0,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,p,s,t],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique19', [all([L,C,P] == [[3,0,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,p,s,t]],[c,c,p,p,s,s,t,t],L,C,P).


    test('jouerCoupHeuristique20', [all([L,C,P] == [[3,0,t]])]) :-
        jouerCoupHeuristique([[c,0,0,0],[p,0,0,0],[s,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique21', [all([L,C,P] == [[3,1,t]])]) :-
        jouerCoupHeuristique([[0,c,0,0],[0,p,0,0],[0,s,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique22', [all([L,C,P] == [[3,2,t]])]) :-
        jouerCoupHeuristique([[0,0,c,0],[0,0,p,0],[0,0,s,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique23', [all([L,C,P] == [[3,3,t]])]) :-
        jouerCoupHeuristique([[0,0,0,c],[0,0,0,p],[0,0,0,s],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique24', [all([L,C,P] == [[2,0,s]])]) :-
        jouerCoupHeuristique([[c,0,0,0],[p,0,0,0],[0,0,0,0],[t,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique25', [all([L,C,P] == [[2,1,s]])]) :-
        jouerCoupHeuristique([[0,c,0,0],[0,p,0,0],[0,0,0,0],[0,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique26', [all([L,C,P] == [[2,2,s]])]) :-
        jouerCoupHeuristique([[0,0,c,0],[0,0,p,0],[0,0,0,0],[0,0,t,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique27', [all([L,C,P] == [[2,3,s]])]) :-
        jouerCoupHeuristique([[0,0,0,c],[0,0,0,p],[0,0,0,0],[0,0,0,t]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique28', [all([L,C,P] == [[1,0,p]])]) :-
        jouerCoupHeuristique([[c,0,0,0],[0,0,0,0],[s,0,0,0],[t,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique29', [all([L,C,P] == [[1,1,p]])]) :-
        jouerCoupHeuristique([[0,c,0,0],[0,0,0,0],[0,s,0,0],[0,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique30', [all([L,C,P] == [[1,2,p]])]) :-
        jouerCoupHeuristique([[0,0,c,0],[0,0,0,0],[0,0,s,0],[0,0,t,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique31', [all([L,C,P] == [[1,3,p]])]) :-
        jouerCoupHeuristique([[0,0,0,c],[0,0,0,0],[0,0,0,s],[0,0,0,t]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique32', [all([L,C,P] == [[0,0,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[p,0,0,0],[s,0,0,0],[t,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique33', [all([L,C,P] == [[0,1,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,p,0,0],[0,s,0,0],[0,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique34', [all([L,C,P] == [[0,2,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,p,0],[0,0,s,0],[0,0,t,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique35', [all([L,C,P] == [[0,3,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,p],[0,0,0,s],[0,0,0,t]],[c,c,p,p,s,s,t,t],L,C,P).


    test('jouerCoupHeuristique36', [all([L,C,P] == [[1,1,t]])]) :-
        jouerCoupHeuristique([[c,s,0,0],[p,0,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique37', [all([L,C,P] == [[1,0,s]])]) :-
        jouerCoupHeuristique([[c,p,0,0],[0,t,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique38', [all([L,C,P] == [[0,1,p]])]) :-
        jouerCoupHeuristique([[c,0,0,0],[s,t,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique39', [all([L,C,P] == [[0,0,c]])]) :-
        jouerCoupHeuristique([[0,p,0,0],[s,t,0,0],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique40', [all([L,C,P] == [[1,3,t]])]) :-
        jouerCoupHeuristique([[0,0,c,p],[0,0,s,0],[0,0,0,0],[t,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique41', [all([L,C,P] == [[1,2,s]])]) :-
        jouerCoupHeuristique([[0,0,c,p],[0,0,0,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique42', [all([L,C,P] == [[0,3,p]])]) :-
        jouerCoupHeuristique([[0,0,c,0],[0,0,s,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique43', [all([L,C,P] == [[0,2,c]])]) :-
        jouerCoupHeuristique([[0,0,0,p],[0,0,s,t],[0,0,0,0],[0,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique44', [all([L,C,P] == [[3,1,t]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,p,0,0],[s,0,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique45', [all([L,C,P] == [[3,0,s]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,p,0,0],[0,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique46', [all([L,C,P] == [[2,1,p]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[c,0,0,0],[s,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique47', [all([L,C,P] == [[2,0,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,p,0,0],[s,t,0,0]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristique48', [all([L,C,P] == [[3,3,t]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,c,p],[0,0,s,0]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique49', [all([L,C,P] == [[3,2,s]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,c,p],[0,0,0,t]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique50', [all([L,C,P] == [[2,3,p]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,c,0],[0,0,s,t]],[c,c,p,p,s,s,t,t],L,C,P).
    test('jouerCoupHeuristique51', [all([L,C,P] == [[2,2,c]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,0,0,0],[0,0,0,p],[0,0,s,t]],[c,c,p,p,s,s,t,t],L,C,P).

    test('jouerCoupHeuristiqueTheLastChance', [true]):-
        jouerCoupHeuristique([[c,p,0,0],[0,0,0,t],[p,c,0,0],[0,0,t,s]],[c,c,p,p,s,s,t,t],1,2,_).
    test('jouerCoupHeuristique1Over0', [all([L,C] == [[1,2]])]) :-
        jouerCoupHeuristique([[0,0,0,0],[0,c,0,0],[c,0,0,t],[p,0,0,s]],[c,c,p,p,s,s,t,t],L,C,_).

:-end_tests(chp0).
