-- SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
-- Copyright Ahmad Ali Parr
module AntProjectionInvariant where  
  
open import Agda.Builtin.Nat  
  using (Nat; zero; suc; _+_)  
  
open import Agda.Builtin.Bool  
  using (Bool; true; false)  
  
open import Agda.Builtin.Equality  
  using (_≡_; refl)  
  
-- Empty type: contradiction  
  
data Bottom : Set where  
  
-- Congruence for equality  
  
cong :  
  {A B : Set} →  
  (f : A → B) →  
  {x y : A} →  
  x ≡ y →  
  f x ≡ f y  
cong f refl = refl  
  
-- Boolean conjunction  
  
_and_ : Bool → Bool → Bool  
true  and b = b  
false and b = false  
  
infixr 6 _and_  
  
-- Three-ant interaction graph.  
-- Edges: 01, 12, 20.  
  
record Graph : Set where  
  constructor graph  
  field  
    edge01 : Bool  
    edge12 : Bool  
    edge20 : Bool  
  
open Graph  
  
-- Cycle indicator.  
-- For a graph on exactly three vertices  
-- with these three possible edges,  
-- the first Betti number is 1 precisely  
-- when all three edges are present.  
--  
-- The complex is one-dimensional:  
-- the triangular face is NOT filled.  
  
cycle : Graph → Bool  
cycle g =  
  edge01 g and  
  (edge12 g and edge20 g)  
  
-- Exact first Betti number for this graph family.  
  
beta1 : Graph → Nat  
beta1 g with cycle g  
... | true  = suc zero  
... | false = zero  
  
-- Temperature-dependent graph projection.  
-- Temperature 1 preserves all edges.  
-- Temperatures 2 and above remove edge20.  
-- Temperature 0 is also identity here,  
-- although physical temperature should be  
-- restricted to positive values.  
  
temperatureProjection : Nat → Graph → Graph  
temperatureProjection zero g = g  
temperatureProjection (suc zero) g = g  
temperatureProjection (suc (suc n)) g =  
  graph (edge01 g) (edge12 g) false  
  
-- Conditional invariant theorem.  
-- If projection preserves the graph,  
-- it preserves the first Betti number.  
  
projectionInvariant :  
  (t : Nat) →  
  (g : Graph) →  
  temperatureProjection t g ≡ g →  
  beta1 (temperatureProjection t g)  
    ≡ beta1 g  
projectionInvariant t g equality =  
  cong beta1 equality  
  
-- Temperature 1 preserves every graph.  
  
temperatureOneIdentity :  
  (g : Graph) →  
  temperatureProjection (suc zero) g ≡ g  
temperatureOneIdentity g = refl  
  
-- Therefore temperature 1 preserves beta1.  
  
temperatureOneInvariant :  
  (g : Graph) →  
  beta1 (temperatureProjection (suc zero) g)  
    ≡ beta1 g  
temperatureOneInvariant g =  
  projectionInvariant  
    (suc zero)  
    g  
    (temperatureOneIdentity g)  
  
-- Concrete three-ant cycle.  
  
triangle : Graph  
triangle = graph true true true  
  
-- The original cycle has beta1 = 1.  
  
triangleBeta :  
  beta1 triangle ≡ suc zero  
triangleBeta = refl  
  
-- Temperature 1 preserves the cycle.  
  
preservedBeta :  
  beta1 (temperatureProjection (suc zero) triangle)  
    ≡ suc zero  
preservedBeta = refl  
  
-- Temperature 2 removes one edge.  
  
brokenBeta :  
  beta1  
    (temperatureProjection  
      (suc (suc zero))  
      triangle)  
    ≡ zero  
brokenBeta = refl  
  
-- Constructive proof that 1 is not 0.  
  
oneNotZero : suc zero ≡ zero → Bottom  
oneNotZero ()  
  
-- The unrestricted preservation claim  
-- fails for this concrete counterexample.  
  
counterexample :  
  beta1  
    (temperatureProjection  
      (suc (suc zero))  
      triangle)  
    ≡ beta1 triangle →  
  Bottom  
counterexample ()  
