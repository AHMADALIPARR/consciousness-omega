# Layout

`source-notes.md` is the original working log, exactly as attached. Code was taken out of it unchanged. Each source file starts with two comment lines (SPDX identifier and copyright); everything after them is the source text, byte for byte. Line numbers below are lines of `source-notes.md`.

## BQN

| File | Source lines | What it is |
|---|---|---|
| `bqn/phi_integrated_information.bqn` | 31-101 | Φ and subsystem partition analysis (KL, partitioned TPM, ComputePhi) |
| `bqn/entropy_kl_mutual_info.bqn` | 197-213 | Von Neumann entropy, KL divergence, mutual information |
| `bqn/f2_cohomology_telemetry.bqn` | 263-287 | F2 cohomology signature vs temperature numerators (kernel 002) |
| `bqn/recursive_ant_telemetry.bqn` | 432-492 | Ant traversal and recursive ant loop (SCM-002) |
| `bqn/finite_field_mersenne.bqn` | 647-678 | Quadratic extension arithmetic mod 2147483647, plus Smash |
| `bqn/finite_field_z_q_extension.bqn` | 725-749 | Z_Q[i] kernel with Q = 2462 (appears unfenced after the Haskell continuation) |
| `bqn/functor_loss_swarm.bqn` | 1086-1093 | EvaluateFunctorLoss |
| `bqn/obstruction_extraction.bqn` | 1126-1143 | ExtractObstruction |
| `bqn/swarm_sweep.bqn` | 1147-1163 | SwarmSweep |

## Lean 4

| File | Source lines | What it is |
|---|---|---|
| `lean/ConsciousnessFormalization.lean` | 106-165 | KL non-negativity and the P / E non-equivalence statement |
| `lean/FunctorialBridgeTemplate.lean` | 220-241 | Template for the functorial bridge (PhysicalSystem, InformationStructure, ExperientialMapping) |

## Agda

| File | Source lines | What it is |
|---|---|---|
| `agda/AntTensorProjectionF2Pathway.agda` | 294-353 | F2 pathway version: temperatureProjection, cohomologySignature, IsOdd, projectionInvariant_F2 |
| `agda/AntTensorProjectionKernelExtension.agda` | 367-423 | Kernel extension version: thermalDecoherence, cohomologySignature, projectionInvariant |
| `agda/AntProjectionInvariant.agda` | 752-906 | Three-ant graph, beta1, counterexample |
| `agda/AntTensorProjectionProof.agda` | 908-984 | Tensor projection proof module |
| `agda/RecursiveAntTensorProjection/Core.agda` | 987-1065 | Core algebraic structures (path matches the module name) |
| `agda/ExperientialFunctorCore.agda` | 1067-1084 | Experiential functor record |
| `agda/NonReductionistWitness.agda` | 1095-1124 | Non-reductionist witness and proveNonReductionism |

The two blocks at 294 and 367 are two separate versions of the same module, so they are separate files.

## Haskell

| File | Source lines | What it is |
|---|---|---|
| `haskell/AlgebraicTokenProjection.hs` | 505-622, then 696-723 | Gaussian integers, Embedding, smash, smashTokens (505-622), plus the file's continuation with the modular Gaussian arithmetic (696-723) |

The continuation at 696 says it is an extension of `AlgebraicTokenProjection.hs`, so the two pieces are joined in source order in one file. The prose between them (lines 623-695) stays in `source-notes.md`.

## Klong

| File | Source lines | What it is |
|---|---|---|
| `klong/quadratic_extension.kg` | 632-641 | badd, bsub, bmul over Z_Q[X]/(X^2 - d); the block is kept exactly as given, including its first line |

The comment header in this file uses Klong's `:"..."` comment form.

## Data

| File | Source lines | What it is |
|---|---|---|
| `data/counterexamples.jsonl` | 360, 1145 | The cycle 2 and cycle 5 records, one per line |

JSON Lines cannot carry comments, so this file has no header. It is covered by the same license as the rest of the repo: AGPL-3.0-only or the SnapKitty Opaque Source License v1.0, at your choice. Copyright Ahmad Ali Parr.

## Docs only

The ASCII category diagrams (lines 3-16 and 168-180) are documentation and stay in `source-notes.md`.
