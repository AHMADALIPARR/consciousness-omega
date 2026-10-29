# Runs

What each tool printed when pointed at the files in this repo, as they are. Run on Linux x86_64 on 2026-10-28.

## BQN (CBQN v0.9.0)

Command: `tools/CBQN/BQN bqn/<file>.bqn`. A file that only defines things prints nothing.

| File | Result |
|---|---|
| `entropy_kl_mutual_info.bqn` | Loads, exit 0. Checked by hand: `Entropy 0.5‿0.5` gives 1, `0.5‿0.5 MutualInfo 0.25‿0.75` gives 0, `0.5‿0.5 KLDivergence 0.25‿0.75` gives 0.20751874963942185. |
| `f2_cohomology_telemetry.bqn` | Loads, exit 0. Its last line evaluates to `⟨ 1 0 1 0 1 ⟩`, the signatures for numerators 1 to 5; the starting signature is 1. This is the data in `docs/img/f2_parity.png`. |
| `functor_loss_swarm.bqn` | Loads, exit 0. |
| `obstruction_extraction.bqn` | Loads, exit 0. |
| `finite_field_mersenne.bqn` | Stops with `Error: Role of the two sides in assignment must match` at the `Q ←` line. |
| `finite_field_z_q_extension.bqn` | Stops with the same error at its `Q ←` line. |
| `recursive_ant_telemetry.bqn` | Stops with the same error at its `TorusBound ←` line. |
| `swarm_sweep.bqn` | Stops with the same error at its `TorusBound ←` line. |
| `phi_integrated_information.bqn` | Stops with `Error: Unknown characters: ⁑𝕪𝕪𝕪⍴⊤`. No Φ value was produced. |

## Lean 4 (v4.35.0, Mathlib v4.35.0)

Mathlib was fetched with `lake update` and `lake exe cache get` (9031 cached files, about a minute). `lake build` then stops at the imports:

- `ConsciousnessFormalization.lean`: `bad import 'Mathlib.Probability.InformationTheory.KullbackLeibler'`. Mathlib v4.35.0 has no module by that name; the KL file in this Mathlib is `Mathlib/InformationTheory/KullbackLeibler/Basic.lean`.
- `FunctorialBridgeTemplate.lean`: `bad import 'Mathlib.InformationTheory.Entropy'`. No module by that name in this Mathlib.

Lean did not get as far as the theorem bodies or the `sorry`, so there is no checker output for them.

## Agda 2.6.4.3

Command: `agda agda/<file>.agda` from the repo root.

| File | Result |
|---|---|
| `AntProjectionInvariant.agda` | Checks, no errors. |
| `AntTensorProjectionProof.agda` | Checks, no errors. |
| `AntTensorProjectionF2Pathway.agda` | `Not in scope: Nat` at 7,17-20 (line numbers as in the repo file, which has two header lines). |
| `AntTensorProjectionKernelExtension.agda` | `Not in scope: ≡` at 8,46-47. |
| `RecursiveAntTensorProjection/Core.agda` | `Not in scope: ≡` at 68,44-45. |
| `ExperientialFunctorCore.agda` | Imports `Core`, so it stops at the same error. |
| `NonReductionistWitness.agda` | Imports `Core`, so it stops at the same error. |

## Haskell (GHC 9.6.3, Liquid Haskell 0.9.6.3.1, z3 4.12.1)

`cabal build` fetched and built the dependencies and Liquid Haskell, then compiled `AlgebraicTokenProjection` with the plugin on. GHC stopped with:

```
haskell/AlgebraicTokenProjection.hs:143:16: error: [GHC-88464]
    Variable not in scope: e :: Integer
haskell/AlgebraicTokenProjection.hs:144:16: error: [GHC-88464]
    Variable not in scope: e :: Integer
```

These are the uses of `e` in the `mulGaussianMod` bindings (`bd = b * e`, `ad = a * e`). The Liquid Haskell checker did not get to run on the file. Plain `ghc -fno-code` 9.6.6 gives the same two errors.

## Klong (20221212)

`kg -l ./klong/quadratic_extension.kg` prints:

```
kg: error: "./klong/quadratic_extension.kg": 3: expected monad, got: :::
```

The interpreter also does not stop at end of input in its prompt, so the Makefile runs it under `timeout`.
