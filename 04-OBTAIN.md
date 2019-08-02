
### Wait, how can I make sure the router I am bundling is current?

Well here's how I once did it in a Makefile:

``` Make
# geti2p is an alias for i2pinstaller.exe
geti2p: i2pinstaller.exe

# This downloads the I2P installer using the url composed by the 'make url'
# target.
i2pinstaller.exe: url
	wget -c `cat geti2p.url` -O i2pinstaller.exe

# This fetches an RDF listing of I2P versions from launchpad and looks for
# the most recent stable version. Using this information, it then constructs
# a URL to download the Windows I2P router installer from Launchpad.
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
```
