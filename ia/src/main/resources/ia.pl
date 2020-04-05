% prolog ia

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