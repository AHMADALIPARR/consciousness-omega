-- SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
-- Copyright Ahmad Ali Parr
module ExperientialFunctorCore where  
  
open import RecursiveAntTensorProjection.Core  
  
-- Define the Codomain Category of Experiential Structures (E)  
record ExperientialStructure : Set where  
  constructor mkExperience  
  field  
    qualiaDimension : Nat  
    isUnified       : Set -- Witness for non-decomposability  
  
-- Proposed Functor G mapping Information Structures (FiniteComplex) to ExperientialStructures  
record ExperientialFunctor (n : Nat) : Set where  
  constructor mkFunctor  
  field  
    mapObj : FiniteComplex n → ExperientialStructure  
    -- Condition: Preservation of structural limits fails if obstruction is non-zero  
    preservesLimits : Set ⊎ (ExperientialStructure → Set)  
