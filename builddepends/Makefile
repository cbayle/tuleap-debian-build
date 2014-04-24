#
NPM_DEPS=node-ansi node-ansi-color-table node-archy \
	node-block-stream node-fstream node-fstream-ignore \
	node-github-url-from-git node-graceful-fs node-ini \
	node-lockfile node-mkdirp node-gyp node-npmlog \
	node-once node-osenv node-read node-read-package-json \
	node-retry node-rimraf 
NPMGYP_DEPS=node-request node-tar node-which
NPMREQ_DEPS=node-uuid node-mime node-forever-agent node-tunnel-agent \
	node-json-stringify-safe node-qs node-cookie-jar node-form-data \
	node-combined-stream node-async node-delayed-stream \
	node-mute-stream node-read-package-json \
	node-normalize-package-data node-sha node-slide

PKGVAGRANT=vagrant ruby-net-ssh ruby-net-scp

# 1st List of package to build
PKGLIST1=php-mail-mbox node-lru-cache node-sigmund node-minimatch \
	node-inherits node-glob uglifyjs node-nopt node-abbrev \
	$(NPM_DEPS) $(NPMGYP_DEPS) $(NPMREQ_DEPS) $(PKGVAGRANT)

# 2nd list of packages who requires first list to be built
PKGLIST2=npm colors.js underscore node-semver

# list of patched packages
PKGPATCHED=twitter-recess less.js-1.3.3 mediawiki

# list of package to download
PKGLIST=$(PKGLIST1) $(PKGLIST2) $(PKGVAGRANT)

# You can use the following as a make argument make BUILDDIR=/some/place
BUILDDIR=$(HOME)/build

# This will make a list of build/src_builddeps/<pkg1> build/...
PKGBUILDDIR1=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGLIST1))
PKGBUILDDIR2=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGLIST2))
PKGBUILDPATCHED=$(patsubst %,$(BUILDDIR)/src_builddeps/%,$(PKGPATCHED))

PKGBUILDDIR=$(PKGBUILDDIR1) $(PKGBUILDDIR2) $(PKGBUILDPATCHED)

PBUILDERRESULTDIR=$(BUILDDIR)/result_builddeps
REPODIR=/var/www/localrepo
DISTRO=debian
DISTRIB=wheezy
SRCDISTRIB=sid
DEBREPO=http://cdn.debian.net/debian
LOCALREPO=http://127.0.0.1/localrepo/$(DISTRO)
ASKPASS=--ask-passphrase
ASKPASS=
PBUILDEROPS=--distribution $(DISTRIB) --othermirror 'deb $(DEBREPO) $(DISTRIB)-backports main'
PBUILDEROPS2=--distribution $(DISTRIB) --othermirror 'deb $(LOCALREPO) $(DISTRIB) main|deb $(DEBREPO) $(DISTRIB)-backports main' --keyring $(REPODIR)/botkey.gpg --override-config

GREEN=[01;32m
RED=[01;31m
NORMAL=[00m


default: depends getsource dgetsource ignorerubytesterr buildbin1 fillrepo buildbin2 fillrepo buildpatched fillrepo

getsource: $(BUILDDIR) $(BUILDDIR)/src_builddeps $(BUILDDIR)/apt
	@echo "Get Source"
	@[ -f $(BUILDDIR)/src_builddeps/done ] || apt-get -qq \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		update
	@touch $(BUILDDIR)/src_builddeps/done
	@cd $(BUILDDIR)/src_builddeps ; \
	for pkg in $(PKGLIST) ; do \
	filename=`expr "$${pkg}_*.dsc"`; \
	if [ -f $$filename ]; then \
		echo "===== Already got `ls $$filename` ====="; \
	else \
		echo "===== Getting $$pkg ====="; \
		apt-get -qq \
		-o Dir=$(BUILDDIR)/apt \
		-o Debug::NoLocking=1 \
		-o Dir::Etc::SourceList="$(CURDIR)/sources.list" \
		source --download-only $$pkg ;\
	fi; \
	done

dgetsource:
	@cd $(BUILDDIR)/src_builddeps ; \
	#[ -f vagrant_1.2.2-1.dsc ] || dget -d http://archive.ubuntu.com/ubuntu/pool/universe/v/vagrant/vagrant_1.2.2-1.dsc ; \
	#[ -f ruby-childprocess_0.3.9-2.dsc ] || dget -d http://archive.ubuntu.com/ubuntu/pool/main/r/ruby-childprocess/ruby-childprocess_0.3.9-2.dsc ; \
	#[ -f ruby-net-scp_1.1.1-1.dsc ] || dget -d http://archive.ubuntu.com/ubuntu/pool/universe/r/ruby-net-scp/ruby-net-scp_1.1.1-1.dsc; \
	#[ -f ruby-net-ssh_2.6.7-1.dsc ] || dget -d http://archive.ubuntu.com/ubuntu/pool/universe/r/ruby-net-ssh/ruby-net-ssh_2.6.7-1.dsc

cleanpbuilder1:
	rm $(PBUILDERRESULTDIR)/preparebuildbin1

cleanpbuilder2:
	rm $(PBUILDERRESULTDIR)/preparebuildbin2

$(PBUILDERRESULTDIR)/preparebuildbin1: $(PBUILDERRESULTDIR)
	[ -f $@ ] || sudo pbuilder --create $(PBUILDEROPS)
	touch $@

ignorerubytesterr:
	if ! grep -q DH_RUBY_IGNORE_TESTS $(HOME)/.pbuilderrc 2>/dev/null ; then \
		echo "export DH_RUBY_IGNORE_TESTS=all" >> $(HOME)/.pbuilderrc ;\
	fi 


buildbin1: $(PBUILDERRESULTDIR)/preparebuildbin1 $(PBUILDERRESULTDIR)
	@echo "Build phase 1"
	@for pkg in $(PKGBUILDDIR1); do \
		filename=`expr "$${pkg}_*.dsc"`; \
		basename=`basename $$filename`; \
		if [ -f $$filename ]; then \
			if [ ! -f $(PBUILDERRESULTDIR)/$$basename ]; then\
				( \
				echo "===== Building $$basename =====" ;\
				sudo pbuilder --build $(PBUILDEROPS) \
				--buildresult $(PBUILDERRESULTDIR) $$filename; \
				) \
			else \
				echo "===== Already build $$basename =====" ;\
			fi \
		else \
			echo "===== Could not find source for $$pkg =====" ;\
		fi; \
	done

$(PBUILDERRESULTDIR)/preparebuildbin2:
	[ -f $@ ] || sudo pbuilder --update $(PBUILDEROPS2) 
	[ -f $@ ] || sudo pbuilder --update $(PBUILDEROPS2) 
	touch $@

buildbin2: $(PBUILDERRESULTDIR)/preparebuildbin2
	@echo "Build phase 2"
	@for pkg in $(PKGBUILDDIR2); do \
		filename=`expr "$${pkg}_*.dsc"`; \
		basename=`basename $$filename`; \
		if [ -f $$filename ]; then \
			if [ ! -f $(PBUILDERRESULTDIR)/$$basename ]; then\
				( \
				echo "===== Building $$basename =====" ;\
				sudo pbuilder --build $(PBUILDEROPS2) \
				--buildresult $(PBUILDERRESULTDIR) $$filename; \
				) \
			else \
				echo "===== Already build $$basename =====" ;\
			fi \
		else \
			echo "===== Could not find source for $$pkg =====" ;\
		fi; \
	done

preparepatched:
	make -C patched

buildpatched: preparepatched
	@echo "Build patched"
	@for pkg in $(PKGBUILDPATCHED); do \
		filename=`expr "$${pkg}_*.dsc"`; \
		basename=`basename $$filename`; \
		if [ -f $$filename ]; then \
			if [ ! -f $(PBUILDERRESULTDIR)/$$basename ]; then\
				( \
				echo "===== Building $$basename =====" ;\
				sudo pbuilder --build $(PBUILDEROPS2) \
				--buildresult $(PBUILDERRESULTDIR) $$filename; \
				) \
			else \
				echo "===== Already build $$basename =====" ;\
			fi \
		else \
			echo "===== Could not find source for $$pkg =====" ;\
		fi; \
	done

fillrepo: preparerepo $(REPODIR)
	@for changefile in $(shell ls $(PBUILDERRESULTDIR)/*.changes); do \
	[ -f $(REPODIR)/$(DISTRO)/pool/main/*/*/`basename $$changefile|sed 's/\(.*\)_\(.*\)_.*\(.changes\)/\1_*\2_*\3/'` ] || \
	(echo "== `basename $$changefile|sed 's/\(.*\)_\(.*\)_.*\(.changes\)/\1_*\2_*\3/'` ==" ; \
	reprepro --ignore=wrongdistribution --ignore=missingfile $(ASKPASS) \
		-Vb $(REPODIR)/$(DISTRO) include $(DISTRIB) $$changefile); \
	done

list:
	@for pkg in $(PKGBUILDDIR) ; do \
		filename=`expr "$${pkg}_*.dsc"`; \
		if [ -f $$filename ]; then \
			basename=`basename $$filename`; \
			basepkg=`echo $$basename|cut -d"_" -f1`; \
			baseletter=`echo $$basepkg|cut -c1`; \
			poolname="$(REPODIR)/$(DISTRO)/pool/main/$$baseletter/$$basepkg/$$basename"; \
			if [ -f "$$poolname" ]; then \
				echo "$(GREEN)[OK]$(NORMAL) $$basename" ; \
			else \
				echo "$(RED)[K0]$(NORMAL) $$basename" ; \
			fi;\
		else \
			echo "$$pkg not found";\
		fi; \
	done

$(RESULDIR)/%.dsc:
	sudo pbuilder --build $(shell basename $@) --debbuildopts -sa

#
# Prepare repository
#
preparerepo:
	@[ -d $(REPODIR)/$(DISTRO)/pool ] || make -C ../repo

#
# Some directories
#
$(BUILDDIR):
	[ -d $@ ] || mkdir $@

$(BUILDDIR)/apt:
	[ -d $@ ] || mkdir $@
	[ -d $@/etc/apt/sources.list.d ] || mkdir -p $@/etc/apt/sources.list.d
	[ -d $@/var/lib/apt/lists/partial ] || mkdir -p $@/var/lib/apt/lists/partial
	[ -d $@/var/cache/apt/lists/partial ] || mkdir -p $@/var/cache/apt/lists/partial
	[ -d $@/etc/apt/preferences.d ] || mkdir -p $@/etc/apt/preferences.d

$(BUILDDIR)/src_builddeps:
	[ -d $@ ] || mkdir $@

$(PBUILDERRESULTDIR):
	[ -d $@ ] || mkdir -p $@

depends: /usr/lib/cdbs /usr/bin/quilt

/usr/lib/cdbs:
	sudo apt-get install cdbs

/usr/bin/quilt:
	sudo apt-get install quilt
