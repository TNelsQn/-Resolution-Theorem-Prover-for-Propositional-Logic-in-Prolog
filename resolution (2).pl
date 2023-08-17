/*
1. ['YES']
2. ['YES']
3. ['YES']
4. ['NO']
5. ['YES']
6. ['YES']
7. ['YES']
8. ['NO']
9. ['NO']
10. ['YES']
*/ 

/* Dual Clause Form Program
Propositional operators are: neg, and, or, imp, revimp,
uparrow, downarrow, notimp and notrevimp.

binary operators are: equiv and notequiv.
*/

?- op(140, fy, neg).
?- op(160, xfy, [and, or, imp, revimp, uparrow, downarrow, notimp, notrevimp, equiv, notequiv]). 

/* member (Item, List) :- Item occurs in List.
*/

member(X, [X | _]).
member(X, [_ | Tail]) :- member(X, Tail).

/* remove (Item, List, Newlist) :-
Newlist is the result of removing all occurrences of
Item from List.
*/

remove(_, [], []).
remove(X, [X | Tail], Newtail) :- remove(X, Tail, Newtail).
remove(X, [Head | Tail], [Head | Newtail]) :- remove(X, Tail, Newtail).

/* conjunctive (X) :- X is an alpha formula.
*/

conjunctive(_ and _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _).

/* disjunctive (X) :- X is a beta formula.
*/

disjunctive(neg(_ and _)).
disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)).

/* unarybinary (X) :- X is a double negation,
or a negated constant, or a binary opeartor.
*/

unarybinary(neg neg _).
unarybinary(neg true).
unarybinary(neg false).
unarybinary(_ equiv _).
unarybinary(_ notequiv _).
unarybinary(neg(_ equiv _)).
unarybinary(neg(_ notequiv _)).

/* components (X, Y, Z) Y and Z are the components
of the formula X, as defined in the alpha and
beta table. 
*/

components(X and Y, X, Y).
components(neg(X and Y), neg X, neg Y).
components(X or Y, X, Y).
components(neg(X or Y), neg X, neg Y).
components(X imp Y, neg X, Y).
components(neg(X imp Y), X, neg Y).
components(X revimp Y, X, neg Y).
components(neg(X revimp Y), neg X, Y).
components(X uparrow Y, neg X, neg Y).
components(neg(X uparrow Y), X, Y).
components(X downarrow Y, neg X, neg Y).
components(neg(X downarrow Y), X, Y).
components(X notimp Y, X, neg Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y). 

/* component(X, Y) Y is the component of the
unary formula X or binary formula X.
*/

component(neg neg X, X).
component(neg true, false).
component(neg false, true).
component(X equiv Z, (neg(X) and neg(Z)) or (X and Z)).
component(X notequiv Z, (neg(X) and Z) or (X and neg(Z))).
component(neg(X equiv Z), (neg(X) and Z) or (X and neg(Z))).
component(neg(X notequiv Z), (neg(X) and neg(Z)) or (X and Z)).

/* singlestep(Old, New) :- New is the result of applying
a single step of the expansion process to Old, which
is a generalized disjunction of generalized
conjunctions.
*/

singlestep([Conjunction | Rest], New) :- 
    member(Formula, Conjunction),
    unarybinary(Formula),
    component(Formula, Newformula),
    remove(Formula, Conjunction, Temporary),
    Newconjunction = [Newformula | Temporary],
    New = [Newconjunction | Rest].

singlestep([Conjunction | Rest], New) :-
    member(Alpha, Conjunction),
    conjunctive(Alpha),
    components(Alpha, Alphaone, Alphatwo),
    remove(Alpha, Conjunction, Temporary),
    Newconone = [Alphaone | Temporary],
    Newcontwo = [Alphatwo | Temporary],
    New = [Newconone, Newcontwo | Rest].

singlestep([Conjunction | Rest], New) :-
    member(Beta, Conjunction),
    disjunctive(Beta),
    components(Beta, Betaone, Betatwo), 
    remove(Beta, Conjunction, Temporary),
	Newcon = [Betaone, Betatwo | Temporary],
	New = [Newcon | Rest]. 

singlestep([Conjunction | Rest], [Conjunction | Newrest]) :-
    singlestep(Rest, Newrest).

/* expand(Old, New) :- New is the result of applying
singlestep as many times as possible, starting
with Old.
*/

expand(Dis, Newdis) :-
    singlestep(Dis, Temp),
    expand(Temp, Newdis).

expand(Dis, Dis). 

/* dualclauseform(X, Y) :- Y is the dual clause form of X.
*/

clauseform(X, Y) :- expand([[X]], Y).


/* simplify(X, Y) :- Y is the form of the list X with no duplicate values.
*/

simplify([],[]).

simplify([Head | Tail], Result) :-
    member(Head, Tail), !,
    simplify(Tail, Result).

simplify([Head | Tail], [Head | Result]) :-
    simplify(Tail, Result).

/* resolutionrule(D1, D2, NewDisjunction) :- applys the resolution rule again and again until all literals and coresponding
 *  negative literals have been removed from D1 and D2.  Then returns NewDisjunction which is the combination of the two.
*/

resolutionrule(D1, D2, NewDisjunction) :-
    member(X, D1),
    unarybinary(neg X),
	component(neg X, Y),
    member(Y, D2),
    remove(X, D1, ND1),
    remove(Y, D2, ND2),
    resolutionrule(ND1, ND2, NewDisjunction).

resolutionrule(D1, D2, NewDisjunction) :-
    member(X, D1),
    member(neg(X), D2),
    remove(X, D1, ND1),
    remove(neg(X), D2, ND2),
    resolutionrule(ND1, ND2, NewDisjunction).

resolutionrule(D1, D2, NewDisjunction) :-
    append(D1, D2, Temp),
	simplify(Temp, NewDisjunction).


/* resolutionstep([Disjunction | Rest], New) :- finds disjunctions that can have the resolution rule applied and applies it to them.
 * returns when there are no more resolutions to be found.
*/

resolutionstep([Disjunction | Rest], New) :-
    member(X, Disjunction),
    unarybinary(neg X),
    component(neg X, Y),
    member(NextDisjunction, Rest),
    member(Y, NextDisjunction),
    resolutionrule(Disjunction, NextDisjunction, Result),
    remove(NextDisjunction, Rest, Iterate),
    New = [Result | Iterate].

resolutionstep([Disjunction | Rest], New) :-    
    member(X, Disjunction),
    member(NextDisjunction, Rest),
    member(neg(X), NextDisjunction),
    resolutionrule(Disjunction, NextDisjunction, Result),
    remove(NextDisjunction, Rest, Iterate),
    New = [Result | Iterate].


/* resolution(Dis, Newdis) :- starts the resolution proof.  returns when can no longer apply an more resolutionsteps.
 * If [] is found before completely expanding the resolution will exit early as no further expansion needed.
*/

resolution(Dis, _) :-
    member([], Dis).

resolution(Dis, Newdis) :-
    resolutionstep(Dis, Temp),
    resolution(Temp, Newdis).

resolution(Dis, Dis).

if_then_else(P, Q, _) :- P, !, Q.

if_then_else(_, _, R) :- R.  

/* final(Y) :- checks if the empty clause has been found.
*/

final(Y) :- member([], Y).


test(X) :- expand([[neg(X)]], R), resolution(R, Y), if_then_else(final(Y), yes, no).

/* yes and no write "yes" and "no" to the console respectively.
*/

yes :- write("YES").

no :- write("NO").