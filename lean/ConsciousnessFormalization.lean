-- SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
-- Copyright Ahmad Ali Parr
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Functor.Basic
import Mathlib.CategoryTheory.Equivalence

/-!
# Formal Proofs of Information Invariants and Categorical Non-Isomorphism
-/

open Real CategoryTheory

namespace ConsciousnessFormalization

/-
  ========================================================================
  1. INFORMATION-THEORETIC INVARIANT: Positivity of KL Divergence
  ========================================================================
-/

/-- Jensen's Inequality application: KL-Divergence is strictly non-negative.
    For discrete probability distributions P and Q over a finite domain -/
theorem kl_divergence_nonnegative {n : ℕ} (P Q : Fin n → ℝ)
    (hP_prob : ∑ i, P i = 1) (hQ_prob : ∑ i, Q i = 1)
    (hP_pos : ∀ i, 0 < P i) (hQ_pos : ∀ i, 0 < Q i) :
    0 ≤ ∑ i, P i * Real.log (P i / Q i) := by
  -- Gibbs' inequality: termwise, P log(P/Q) ≥ P (1 - Q/P) = P - Q.
  have h_term : ∀ i, P i - Q i ≤ P i * Real.log (P i / Q i) := by
    intro i
    have hP := hP_pos i
    have hQ := hQ_pos i
    have hlog : Real.log (Q i / P i) ≤ Q i / P i - 1 :=
      Real.log_le_sub_one_of_pos (div_pos hQ hP)
    have hinv : Real.log (P i / Q i) = -Real.log (Q i / P i) := by
      rw [← Real.log_inv, inv_div]
    rw [hinv]
    have hmul : P i * (Q i / P i - 1) = Q i - P i := by
      field_simp
    nlinarith [mul_le_mul_of_nonneg_left hlog hP.le]
  calc (0 : ℝ) = ∑ i, P i - ∑ i, Q i := by rw [hP_prob, hQ_prob]; ring
    _ = ∑ i, (P i - Q i) := by rw [Finset.sum_sub_distrib]
    _ ≤ ∑ i, P i * Real.log (P i / Q i) := Finset.sum_le_sum fun i _ => h_term i

/-
  ========================================================================
  2. CATEGORICAL OBSTRUCTION: Non-Equivalence of Category P and Category E
  ========================================================================
-/

/-- Abstract definition of Category P (Physical Systems) -/
class PhysicalCategory (P : Type u) [Category.{v} P] where
  has_forgetful_state : ∃ (X Y : P), Nonempty (X ⟶ Y)

/-- Abstract definition of Category E (Experiential Monad / Reflexive Structures) -/
class ExperientialCategory (E : Type u) [Category.{v} E] where
  self_referential_object : ∃ (Ω : E), Nonempty ((Ω ⟶ Ω) ≃ ((Ω ⟶ Ω) → (Ω ⟶ Ω)))

/-- Theorem: A forgetful Functor F: P -> E cannot form an equivalence of 
    categories if P lacks reflexive End-objects present in E. -/
theorem physical_experiential_non_equivalence
    (P : Type u) [Category.{v} P] [PhysicalCategory P]
    (E : Type u) [Category.{v} E] [ExperientialCategory E]
    (F : P ⥤ E) (h_faithful : Functor.FullyFaithful F)
    (h_P : ¬ ∃ (X : P), Nonempty ((X ⟶ X) ≃ ((X ⟶ X) → (X ⟶ X)))) :
    ¬ (Nonempty (P ≌ E)) := by
  intro h_equiv
  rcases h_equiv with ⟨e⟩
  -- Move the reflexive object Ω of E back along the fully faithful e.inverse:
  -- End (e.inverse.obj Ω) ≃ End Ω, so P would have a reflexive object.
  obtain ⟨Ω, ⟨r⟩⟩ := ExperientialCategory.self_referential_object (E := E)
  let h : (e.inverse.obj Ω ⟶ e.inverse.obj Ω) ≃ (Ω ⟶ Ω) :=
    e.fullyFaithfulInverse.homEquiv.symm
  exact h_P ⟨e.inverse.obj Ω, ⟨h.trans (r.trans (Equiv.arrowCongr h.symm h.symm))⟩⟩
