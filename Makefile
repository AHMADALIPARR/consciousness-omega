# SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-SnapKitty-Opaque-1.0
# Copyright Ahmad Ali Parr
#
# make bqn | lean | agda | haskell | klong | all
# Toolchain versions are listed in docs/toolchains.md.

SHELL := /bin/bash

# ---- pinned toolchains -------------------------------------------------
CBQN_REPO    := https://github.com/dzaima/CBQN
CBQN_TAG     := v0.9.0
CBQN_COMMIT  := 108379f121260e09c008230b6445080850ee4168

KLONG_URL    := https://t3x.org/klong/klong20221212.tgz
KLONG_SHA256 := 5e1a4877228a3c643a99dbfd2d73e60bc3fa856e2615ac2fe78c80370e7f96b4

GHC_VERSION   := 9.6.3
CABAL_VERSION := 3.10.3.0
LH_VERSION    := 0.9.6.3.1
Z3_VERSION    := 4.12.1

TOOLS := $(CURDIR)/tools
BQN   := $(TOOLS)/CBQN/BQN
KG    := $(TOOLS)/klong/kg

BQN_FILES    := $(sort $(wildcard bqn/*.bqn))
AGDA_FILES   := $(sort $(shell find agda -name '*.agda'))
KLONG_FILES  := $(sort $(wildcard klong/*.kg))

.PHONY: all bqn lean agda haskell klong setup-haskell clean distclean

all: bqn klong agda lean haskell

# ---- BQN (CBQN) --------------------------------------------------------
$(BQN):
	mkdir -p $(TOOLS)
	git clone $(CBQN_REPO) $(TOOLS)/CBQN
	cd $(TOOLS)/CBQN && git checkout $(CBQN_COMMIT) \
	  && git submodule update --init build/bytecodeSubmodule build/replxxSubmodule \
	  && make -j4

# Runs every kernel file, then shows the value of its last expression.
bqn: $(BQN)
	@for f in $(BQN_FILES); do \
	  echo "== $$f"; \
	  $(BQN) $$f; echo "   exit: $$?"; \
	  $(BQN) -e "•Show •BQN •file.Chars \"$$f\""; \
	done; true

# ---- Klong -------------------------------------------------------------
$(KG):
	mkdir -p $(TOOLS)
	curl -sL -o $(TOOLS)/klong20221212.tgz $(KLONG_URL)
	echo "$(KLONG_SHA256)  $(TOOLS)/klong20221212.tgz" | sha256sum -c -
	cd $(TOOLS) && tar xzf klong20221212.tgz
	cd $(TOOLS)/klong && make

# kg keeps reading its prompt at end of input, so the run is time-limited.
klong: $(KG)
	@for f in $(KLONG_FILES); do \
	  echo "== $$f"; \
	  KLONGPATH=$(TOOLS)/klong/lib timeout 5 $(KG) -l ./$$f < /dev/null 2>&1 | head -c 400; echo; \
	done; true

# ---- Agda --------------------------------------------------------------
agda:
	@for f in $(AGDA_FILES); do \
	  echo "== $$f"; \
	  agda $$f && echo "   ok" || echo "   agda exit: $$?"; \
	done; true

# ---- Lean 4 + Mathlib --------------------------------------------------
lean:
	lake exe cache get
	-lake build
	@for f in lean/*.lean; do echo "== $$f"; lake env lean $$f; done; true

# ---- Haskell + Liquid Haskell ------------------------------------------
setup-haskell:
	ghcup install ghc $(GHC_VERSION)
	ghcup install cabal $(CABAL_VERSION)
	@echo "Liquid Haskell $(LH_VERSION) needs z3 $(Z3_VERSION) (or newer 4.x) on PATH."

haskell:
	cabal build

clean:
	rm -rf _build dist-newstyle .lake
	find agda -name '*.agdai' -delete

distclean: clean
	rm -rf $(TOOLS)
