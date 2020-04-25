% prolog ia


grid = [[L1C1, L1C2, L1C3, L1C4],
    [L2C1, L2C2, L2C3, L2C4],
    [L3C1, L3C2, L3C3, L3C4],
    [L4C1, L4C2, L4C3, L4C4]
]


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