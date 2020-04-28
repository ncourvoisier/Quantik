% prolog ia


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
    nth0(Colonne,L,Val).

% This function check if the line contain a pawn
%
% Grid : the grid of Quantik game with preceding move of player
% Ligne : the line to check
% Pion : the pawn to check if is in line
verifLigne(Grid, Ligne, Pion) :-
    nth0(Ligne,Grid,L),
    nth0(_,L,Pion),!.



test(T,Val) :-
    PT = [1,2,3],
    write(PT).






