habite(laurent,vesoul).
habite(fabrice,marseille).
habite(fabien,belfort).
habite(christophe,vesoul).

% règle PROLOG
meme_endroit(X,Y):- habite(X,V),habite(Y,V).

% Les tests unitaires :
:-begin_tests(chp0).
test('habite(X,vesoul)',[true(X==laurent)]):-
    habite(X,vesoul).
test('habiteA(X,vesoul)',[true(X\=christophe)]):-
    habite(X,vesoul).
test('habiteAll(X,vesoul)',[all(X==[laurent,christophe])]):-
    habite(X,vesoul).
test('habiteAllF(X,vesoul)',[all(X==[christophe,laurent])]):-
    habite(X,vesoul).
test('habiteSets(X,vesoul)',[set(X==[christophe,laurent])]):-
    habite(X,vesoul).
test('habite(X,besancon)',[fail]):-
    habite(_X,besancon).
:-end_tests(chp0).

appartient(X,[X|_Y]).
appartient(X,[_Z|Y]):- appartient(X,Y).
