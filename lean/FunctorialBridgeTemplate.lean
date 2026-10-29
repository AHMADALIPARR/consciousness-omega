-- SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
-- Copyright Ahmad Ali Parr
import Mathlib.CategoryTheory.Category.Basic
import Mathlib.CategoryTheory.Functor.Basic
import Mathlib.CategoryTheory.Monoidal.Category
import Mathlib.Basic.Real.Basic

universe u v

-- Define the Physical Category
class PhysicalSystem (P : Type u) extends CategoryTheory.Category P where
  state_transition : P → P → Type v
  IsCPTP : ∀ {x y : P}, (x ⟶ y) → Prop
  cptp_constraint : ∀ (x y : P) (f : x ⟶ y), IsCPTP f

-- Define the Informational Category
class InformationStructure (I : Type u) extends CategoryTheory.Category I where
  entropy_bound : I → ℝ
  mutual_info : I → I → ℝ

open CategoryTheory MonoidalCategory in
-- Conjecture the existence of the Phenomenological Functor
-- This must be rigorously proven, not postulated as an axiom.
structure ExperientialMapping {P I : Type u} [PhysicalSystem P] [InformationStructure I]
    [MonoidalCategory P] [MonoidalCategory I] where
  F : CategoryTheory.Functor P I
  preserves_entanglement : ∀ (x y : P), (F.obj (x ⊗ y)) ≅ (F.obj x) ⊗ (F.obj y)
