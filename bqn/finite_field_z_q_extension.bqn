# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# Z_Q[i] Quotient Ring Kernel Extension  
# Q = 2462 (Anchored to Torus A_{89/2462} mapping)  
Q ← 2462  
  
# Addition over Z_Q[i]  
badd ← { (𝕩 + 𝕨) | Q }  
  
# Subtraction over Z_Q[i]  
bsub ← { (Q + 𝕩 - 𝕨) | Q }  
  
# Multiplication over Z_Q[i]  
# 𝕨 = x (Gaussian pair), 𝕩 = y (Gaussian pair), Q = modulus  
bmul ← {  
  a ← 𝕨 ⊑ 0  
  b ← 𝕨 ⊑ 1  
  c ← 𝕩 ⊑ 0  
  e ← 𝕩 ⊑ 1  
  ac ← (a × c) | Q  
  bd ← (b × e) | Q  
  ad ← (a × e) | Q  
  bc ← (b × c) | Q  
  real_res ← (ac - bd) | Q  
  imag_res ← (ad + bc) | Q  
  real_res ⋈ imag_res  
}  
