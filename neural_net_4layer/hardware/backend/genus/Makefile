# ============================================================
# Makefile for Genus Synthesis
# ============================================================

GENUS := genus
TCL_SCRIPT := synthesis.tcl

.PHONY: all syn clean

all: syn

syn:
	tcsh -c "source /vol/ece303/genus_tutorial/cadence.env && $(GENUS) -files $(TCL_SCRIPT)"

clean:
	rm -rf fv genus.cmd* genus.log* timing.rep area.rep gates.rep power.rep nn_top_syn.v xrun.history
	@echo "Synthesis artifacts cleaned."
