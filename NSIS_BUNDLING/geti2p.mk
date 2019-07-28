geti2p: i2pinstaller.exe

i2pinstaller.exe: url
	wget -c `cat geti2p.url` -O i2pinstaller.exe

url:
	echo -n 'https://launchpad.net' | tee .geti2p.url
	curl -s https://launchpad.net/i2p/trunk/+rdf | \
		grep specifiedAt | \
		head -n 3 | \
		tail -n 1 | \
		sed 's|                <lp:specifiedAt rdf:resource="||g' | \
		sed 's|+rdf"/>||g' | tee -a .geti2p.url
	echo -n '+download/i2pinstall_' | tee -a .geti2p.url
	curl -s https://launchpad.net/i2p/trunk/+rdf | \
		grep specifiedAt | \
		head -n 3 | \
		tail -n 1 | \
		sed 's|                <lp:specifiedAt rdf:resource="/i2p/trunk/||g' | \
		sed 's|/+rdf"/>||g' | tee -a .geti2p.url
	echo '_windows.exe' | tee -a .geti2p.url
	cat .geti2p.url | tr -d '\n' | tee geti2p.url
	rm -f .geti2p.url


