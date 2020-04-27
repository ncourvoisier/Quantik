% prolog ia


pion(cylindre, pave, sphere, tetraedre).
pionN(cn, pn, sn, tn).
pionB(cb, pb, sb, tb).


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
















