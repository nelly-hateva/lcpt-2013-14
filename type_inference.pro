/* Γ ⊢ M : ρ */
/* ⊢(Γ,:(λ(x,$(x,x)),=>(α,α))). */
/* Γ ⊢ λ(x,x $ x) : α => α. */
/* λ(x,λ(y,λ(z,x $ z $ (y $ z)))) */

:- op(150, xfx, ⊢).
:- op(140, xfx, :).
:- op(120, xfy, =>).
:- op(100, yfx, $).

/* Долният флаг указва на SWI Prolog да се прави унификация без цикличност,
   т.е. X = f(X) да пропада, а да не създава безкрайно дърво */
:- set_prolog_flag(occurs_check, true).

/*
Искаме за се използва по следния начин:
  ?- [] ⊢ term : X
  X = <най-общ тип за term>, ако term е типизируем
  false, ако term не е типизируем.
*/
/* atom(x) ---> Yes.
   atom(x $ x) ---> No.
*/

s(λ(x,λ(y,λ(z,x $ z $ (y $ z))))).
omega(λ(x,x $ x)).

Γ ⊢      X : T         :- atom(X), member(X : T, Γ).
Γ ⊢ λ(X,M) : A => B    :- [ X : A | Γ ] ⊢ M : B.
Γ ⊢ M $ N  : B         :- Γ ⊢ M : A => B, Γ ⊢ N : A.

/*
  Примери за използване

?- [x:α,y:β] ⊢ x : T.
T = α ;
false.

?- [] ⊢ λ(x,x) : T.
T = _G242=>_G242 .

?- [] ⊢ λ(x,λ(y,x)) : T.
T = _G248=>_G260=>_G248 

?- s(S), [] ⊢ S : T.
S = λ(x, λ(y, λ(z, x$z$ (y$z)))),
T = (_G67=>_G76=>_G68)=> (_G67=>_G76)=>_G67=>_G68 

?- omega(Omega), [] ⊢ Omega : T.
false.
*/