
help:
	@cat README_REPO.md

new: README rst
	pandoc -p -t html5 --css=style.css --highlight-style=tango -f rst README.rst -o index.html
	#sed -i 's|<blockquote>|<pre><code>|g' index.html
	#sed -i 's|<p>=||g' index.html
	#sed -i 's|</blockquote>|</pre></code>|g' index.html
	#sed -i 's|=</p>||g' index.html
	sed -i 's\|</code></pre>\|\g' index.html
	sed -i 's\<pre><code>=\=\g' index.html
	pandoc -p -t html5 --css=style.css --highlight-style=tango index.html -o README.pdf

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
	torst 00-IMAGE.md | tee IMAGE.rst
	torst PROPOSAL.md | tee PROPOSAL.rst
	torst 01-CURRENT_APIS.md | tee current_apis.rst
	torst 01-I2CP.md | tee i2cp.rst
	torst 01-I2PTUNNEL.md | tee i2ptunnel.rst
	torst 01-I2PCONTROL.md | tee i2pcontrol.rst
	torst 01-SAM.md | tee sam.rst
	torst 02-WHY_AN_API.md | tee which_api.rst
	torst 02-NOTI2PTUNNEL.md | tee noti2ptunnel.rst
	torst 02-BRIDGINGCONCERNS.md | tee bridge.rst
	torst 03-WHAT_IS_SAM.md | tee what_is_sam.rst
	torst 03-STAGES.md | tee sam_stages.rst
	torst 03-HANDSHAKE.md | tee sam_handshake.rst
	torst 03-SESSION.md | tee sam_session.rst
	torst 03-CONNECTIONS.md | tee sam_connection.rst
	torst 03-REUSE.md | tee sam_reuse.rst
	torst 04-BUNDLING.md | tee bundling_i2p.rst
	torst 04-INSTALLER.md | tee installer.rst
	torst 04-OBTAIN.md | tee obtain.rst
	torst 04-JLINK.md | tee jlink.rst
	torst 04-CONFIG.md | tee config.rst
	torst 04-EMBEDDING.md | tee embedding_i2p.rst
	torst 04-CONSIDER.md | tee consider_embedding.rst
	torst 05-WHAT_SAM_CANT_DO.md | tee what_sam_cant_do.rst
	torst 06-EXAMPLES.md | tee examples.rst
	make susc
	cat IMAGE.rst COVER.rst \
		current_apis.rst SPACER.rst \
		i2cp.rst SPACER.rst \
		i2ptunnel.rst SPACER.rst \
		i2pcontrol.rst SPACER.rst \
		sam.rst SPACER.rst \
		which_api.rst SPACER.rst \
		noti2ptunnel.rst SPACER.rst \
		bridge.rst SPACER.rst \
		what_is_sam.rst SPACER.rst \
		sam_stages.rst SPACER.rst \
		sam_handshake.rst SPACER.rst \
		sam_session.rst SPACER.rst \
		sam_connection.rst SPACER.rst \
		sam_reuse.rst SPACER.rst \
		bundling_i2p.rst SPACER.rst \
		installer.rst SPACER.rst \
		obtain.rst SPACER.rst \
		jlink.rst SPACER.rst \
		config.rst SPACER.rst \
		embedding_i2p.rst SPACER.rst \
		consider_embedding.rst SPACER.rst \
		what_sam_cant_do.rst SPACER.rst \
		examples.rst SPACER.rst > README.rst

susc:
	cp $(GOPATH)/src/github.com/eyedeekay/susc/PRINTOUT.rst 03-SUSC.rst
	cat 03-SUSC.rst SPACER.rst | tee -a examples.rst

README:
	@echo "# defcon.prop" | tee README.md
	@echo "Def Con Workshop" | tee -a README.md
	@echo "" | tee -a README.md
	cat COVER.md PROPOSAL.md | tee -a README.md

blogpost-meta:
	@echo '.. meta::' | tee /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
	@echo '    :title: August 2019 Conference Schedule' | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
	@echo '    :author: sadie' | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
	@echo '    :date: 2019-07-29' | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
	@echo '    :excerpt: I2P developers are attending multiple conferences this month' | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
	@echo '' | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst

blogpost: blogpost-meta
	torst blogpost-pre.md | tee -a /media/longterm/desktop-Workspace/mtn/i2p.www/i2p2www/blog/2019/07/29/august-conferences.rst
