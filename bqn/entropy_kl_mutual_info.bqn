# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# BQN Kernel: Von Neumann Entropy Computation
# Assumes 𝕩 is an array of eigenvalues derived from the density matrix
Log2 ← { (⋆⁼ 𝕩) ÷ ⋆⁼ 2 }
Entropy ← { - +´ 𝕩 × Log2 𝕩 }

# Kullback-Leibler Divergence: D_KL(P || Q)
# 𝕨 = P (target distribution), 𝕩 = Q (reference distribution)
KLDivergence ← { +´ 𝕨 × Log2 𝕨 ÷ 𝕩 }

# Rank-polymorphic Mutual Information across tensor network cuts
MutualInfo ← {
  h_w ← Entropy 𝕨
  h_x ← Entropy 𝕩
  h_wx ← Entropy 𝕨 ∾ 𝕩
  (h_w + h_x) - h_wx
}

