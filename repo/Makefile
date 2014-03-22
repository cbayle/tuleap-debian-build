#! /usr/bin/make -f

REPODIR=/var/www/localrepo

DEBIANLIST=1squeeze 2wheezy 3sid
UBUNTULIST=1precise 1trusty

REPOTITLE=My Local Repo
ORIGIN=localhost.localdomain

# SIGNKEY
BOTKEYFILE=botkey
ifeq (,$(shell echo "$$DEBEMAIL"))
DEBEMAIL=buildbot@$(shell hostname -f)
else
DEBEMAIL:=$(shell echo $$DEBEMAIL)
endif
SIGNKEY=$(DEBEMAIL)

ASKPASS=--ask-passphrase
ASKPASS=

default: $(REPODIR)/debian/conf/distributions $(REPODIR)/ubuntu/conf/distributions $(HOME)/.gnupg/secring.gpg repo

%/debian/conf/distributions:
	[ -d $(REPODIR)/debian/conf ] || mkdir -p $(REPODIR)/debian/conf
	for xdist in $(DEBIANLIST) ; do \
	dist=`echo $$xdist | cut -c2-` ; \
	echo "Codename: $$dist" ; \
	echo "Suite: $$dist" ; \
	echo "Components: main" ; \
	echo "UDebComponents: main" ; \
	echo "Architectures: amd64 i386 source" ; \
	echo "Origin: $(ORIGIN)" ; \
	echo "Version: 5.0" ; \
	echo "Tracking: all includechanges" ; \
	echo "Description: $(REPOTITLE) $$dist repository" ; \
	echo "SignWith: $(SIGNKEY)" ; \
	echo "" ; done >> $@

%/ubuntu/conf/distributions:
	[ -d $(REPODIR)/ubuntu/conf ] || mkdir -p $(REPODIR)/ubuntu/conf
	for xdist in $(UBUNTULIST) ; do \
	dist=`echo $$xdist | cut -c2-` ; \
	echo "Codename: $$dist" ; \
	echo "Suite: $$dist" ; \
	echo "Components: main" ; \
	echo "UDebComponents: main" ; \
	echo "Architectures: amd64 i386 source" ; \
	echo "Origin: $(ORIGIN)" ; \
	echo "Version: 5.0" ; \
	echo "Tracking: all includechanges" ; \
	echo "Description: $(REPOTITLE) $$dist repository" ; \
	echo "SignWith: $(SIGNKEY)" ; \
	echo "" ; done >> $@

repo: $(REPODIR)/debian/db $(REPODIR)/ubuntu/db

cleanrepo:
	rm -rf $(REPODIR)/debian/db $(REPODIR)/ubuntu/db

$(REPODIR)/debian/db:
	reprepro $(ASKPASS) -Vb $(REPODIR)/debian export
	reprepro $(ASKPASS) -Vb $(REPODIR)/debian check

$(REPODIR)/ubuntu/db:
	reprepro $(ASKPASS) -Vb $(REPODIR)/ubuntu export
	reprepro $(ASKPASS) -Vb $(REPODIR)/ubuntu check


$(HOME)/.gnupg/secring.gpg: $(BOTKEYFILE)
	[ -d ~/.gnupg ] || gpg --batch --gen-key $(BOTKEYFILE)
	gpg --export --armor | sudo apt-key add -

$(BOTKEYFILE):
	(echo '%echo Generating a standard key' ; \
	echo 'Key-Type: DSA' ; \
	echo 'Key-Length: 1024' ; \
	echo 'Subkey-Type: ELG-E' ; \
	echo 'Subkey-Length: 1024' ; \
	echo 'Name-Real:  Bot key' ; \
	echo 'Name-Comment: with stupid passphrase' ; \
	echo 'Name-Email: $(DEBEMAIL)' ; \
	echo 'Expire-Date: 0' ; \
	echo '#Passphrase: abc' ; \
	echo '#%pubring $(BOTKEYFILE).pub' ; \
	echo '#%secring $(BOTKEYFILE).sec' ; \
	echo '# Do a commit here, so that we can later print "done" :-)' ; \
	echo '%commit' ; \
	echo '%echo done')> $@

cleankey:
	rm -f $(BOTKEYFILE)

clean:
	rm -rf $(REPODIR)/debian/conf $(REPODIR)/ubuntu/conf

preparebuilder:
	sudo pbuilder update --override-config
