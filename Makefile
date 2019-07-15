
new: README rst
	pandoc --highlight-style=tango -f gfm COVER.md -o - | tee index.html
	pandoc --highlight-style=tango -f gfm PROPOSAL.md -o - | tee -a index.html
	pandoc -p --highlight-style=tango -f rst README.rst -o README.pdf

plan:
	pandoc --highlight-style=tango -f gfm PLAN.md -o - | tee -a index.html

meta:
	@echo '.. meta::' | tee COVER.rst
	@echo '    :title: I2P Anonymity for Application Developers' | tee -a COVER.rst
	@echo '    :pagetitle: I2P Anonymity for Application Developers' | tee -a COVER.rst
	@echo '    :author: idk' | tee -a COVER.rst
	@echo '    :date: 2019-06-04' | tee -a COVER.rst
	@echo '    :excerpt: Anonymous APIs and redistributable services are easier than you think' | tee -a COVER.rst
	@echo '' | tee -a COVER.rst
	torst COVER.md | tee -a COVER.rst
	@echo '' | tee -a COVER.rst
	@echo ".. raw:: pdf" | tee -a COVER.rst
	@echo '' | tee -a COVER.rst
	@echo "    PageBreak oneColumn" | tee -a COVER.rst
	@echo '' | tee -a COVER.rst

rst: meta
	torst PROPOSAL.md | tee PROPOSAL.rst
	torst 01-CURRENT_APIS.md | tee current_apis.rst
	torst 02-WHY_AN_API.md | tee which_api.rst
	torst 03-BUNDLING.md | tee bundling_i2p.rst
	torst 04-SETTING_UP_SAM.md | tee setting_up_sam.rst
	cat COVER.rst PROPOSAL.rst > README.rst

README:
	@echo "# defcon.prop" | tee README.md
	@echo "Def Con Workshop" | tee -a README.md
	@echo "" | tee -a README.md
	cat COVER.md PROPOSAL.md | tee -a README.md
