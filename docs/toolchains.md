# Toolchains

| Part | Tool | Version | Pinned in |
|---|---|---|---|
| BQN | CBQN | v0.9.0 (commit 108379f121260e09c008230b6445080850ee4168), built with `make`; no Python needed | `Makefile` |
| Lean 4 | Lean | v4.35.0 | `lean-toolchain` |
| Lean 4 | Mathlib | v4.35.0 (commit 56a005855ea17e0b0958f73ec801ae140b0a1679) | `lakefile.toml`, `lake-manifest.json` |
| Agda | Agda | 2.6.4.3 | `consciousness-omega.agda-lib` (library file), this page |
| Haskell | GHC | 9.6.3 | `cabal.project` |
| Haskell | cabal-install | 3.10.3.0 | `Makefile` |
| Haskell | Liquid Haskell | 0.9.6.3.1 (plugin, needs GHC 9.6.3 exactly) | `consciousness-omega.cabal`, `cabal.project.freeze` |
| Haskell | z3 | 4.12.1 | `Makefile` |
| Klong | Klong (C) | 20221212 by Nils Holm, from t3x.org, SHA256 5e1a4877228a3c643a99dbfd2d73e60bc3fa856e2615ac2fe78c80370e7f96b4 | `Makefile` |

## Notes

**Lean.** Install elan, then run `lake exe cache get` and `lake build`. The `lean-toolchain` file selects Lean v4.35.0 automatically. `make lean` does these steps.

**Agda.** Agda 2.6.4.3 is the version the modules were checked with. The standard library is not needed; the modules define what they use. `make agda` checks each file with `agda`, which finds `consciousness-omega.agda-lib` in the repo root.

**Haskell.** `make setup-haskell` installs GHC 9.6.3 and cabal 3.10.3.0 with ghcup. Put z3 on `PATH`. `make haskell` runs `cabal build` with the Liquid Haskell plugin turned on in the cabal file. The dependency set is frozen in `cabal.project.freeze` and the Hackage index date is set in `cabal.project`. On Linux, ghcup's GHC links with the gold linker, so `ld.gold` has to exist on `PATH`; where it is missing, a symlink to `ld.bfd` works.

**Klong.** There is a reliable C Klong: the interpreter by Nils Holm (t3x.org), written in portable C99. `make klong` downloads that tarball, checks its SHA256, builds `kg`, and loads `klong/quadratic_extension.kg` with it. There is no Python port in this repo.

**BQN.** `make bqn` builds CBQN and runs every file under `bqn/` with it.
