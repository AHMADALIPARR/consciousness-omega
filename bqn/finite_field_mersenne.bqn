# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# CONSCIOUSNESS Ω - BQN FINITE FIELD KERNEL
# Quadratic Extension Arithmetic over 𝔽_Q
Q ← 2147483647 # Prime modulus (Mersenne M31 for deterministic overflow safety)
d ← ¯1         # Gaussian integer extension (i^2 = -1)

# Modulo operator for finite field boundaries
Mod ← { 𝕨 | 𝕩 - 𝕨 × ⌊ 𝕩 ÷ 𝕨 }

# 𝕨 and 𝕩 are algebraic states ⟨real, imag⟩
BAdd ← { Q Mod 𝕨 + 𝕩 }
BSub ← { Q Mod (Q + 𝕨) - 𝕩 }

# Tensor multiplication over the extension field
BMul ← {
  a ‿ b ← 𝕨
  c ‿ e ← 𝕩
  re ← Q Mod (a × c) + d × (b × e)
  im ← Q Mod (a × e) + (b × c)
  re ‿ im
}

# The Liquid Haskell `smash` discrete energy minimizer ported to BQN
# Recursively halves the algebraic state until reaching the vacuum ⟨0,0⟩
# 𝕩: ⟨real, imag⟩ (must be mapped to absolute values prior to entry)
Smash ← {
  Latched ← { (𝕩 ⊑ 0) = 0 ∧ (𝕩 ⊑ 1) = 0 }
  Step ← { ⌊ 𝕩 ÷ 2 }
  
  Loop ← { Latched 𝕩 ? 𝕩 ; Loop Step 𝕩 }
  Loop 𝕩
}

