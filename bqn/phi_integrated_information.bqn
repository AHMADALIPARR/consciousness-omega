# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
# BQN Kernel: Integrated Information (Phi) & Subsystem Partition Analysis
# Target Environment: Pure BQN Engine (BQN CBQN/Wasm)

# --- Auxiliary Math Functions ---
# Natural logarithm over elements (0 log 0 defined as 0)
Log ← { 0=𝕩 ? 0 ; ⋆⁑¯1 𝕩 }
# Element-wise KL Divergence: P * log(P / Q)
KLD ← { 𝕩 × (Log 𝕩) - Log 𝕪 }
# Sum reduction across all axes
Sum ← +/⥊

# --- Kullback-Leibler Divergence Engine ---
# Input: 𝕩 = Vector/Array P (Distribution 1), 𝕪 = Vector/Array Q (Distribution 2)
# Output: Scalar KL-Divergence value D_KL(P || Q)
KL ← {
  p ← 𝕩 ⋄ q ← 𝕪
  Sum p KLD q
}

# --- Marginalization & Partition Tensor Product ---
# Input: 𝕩 = Transition Probability Matrix T (N x N)
#        𝕪 = Binary Partition Vector (Length N, 1=System A, 0=System B)
PartitionedTPM ← {
  T ← 𝕩 ⋄ mask ← 𝕪
  N ← ≡mask
  # Compute marginal distributions for partition A and partition B
  subA ← mask / T
  subB ← (¯1 + mask) / T
  # Outer product re-constitution (assuming independence under partition)
  pA ← (+/subA) ÷ N
  pB ← (+/subB) ÷ N
  reconstructed ← pA ∘.× pB
  reconstructed
}

# --- Main Phi Calculation Engine ---
# Input: 𝕩 = Square Transition Probability Matrix (N x N)
# Output: Scalar Integrated Information Value (Phi)
ComputePhi ← {
  T ← 𝕩
  N ← ⊑≢T
  
  # Generate all non-trivial binary partitions (excluding all-0 and all-1)
  # Partitions generated as binary numbers 1 to (2^N - 2)
  numPartitions ← (2 ⋆ N) - 2
  partitionIndices ← 1 + ↕numPartitions
  
  # Decode indices into binary mask arrays
  GetMask ← { ((N ⍴ 2) ⊤ 𝕩) }
  masks ← GetMask¨ partitionIndices
  
  # Compute KL Divergence for each partition
  EvalPartition ← {
    pTPM ← T PartitionedTPM 𝕩
    T KL pTPM
  }
  
  divergences ← EvalPartition¨ masks
  
  # Minimum Information Partition (MIP) defines Phi
  phi ← ⌊/ divergences
  phi
}

# --- Test Execution with 4-node System TPM ---
# Sample transition matrix (Deterministic/Probabilistic system)
SampleTPM ← 4 4 ⥊ 0.1 0.7 0.1 0.1  0.8 0.05 0.05 0.1  0.0 0.1 0.8 0.1  0.2 0.2 0.2 0.4

# Calculate system Phi
PhiValue ← ComputePhi SampleTPM

