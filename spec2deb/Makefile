#
# This is used to ease th creation on debian package
# You will find most debian required files in -debian tarball
#
VERS=$(shell cat ../../tuleap/VERSION)
default: $(HOME)/rpmbuild/SOURCES/tuleap-$(VERS).tar.gz $(HOME)/rpmbuild/SPECS/tuleap.spec spec2deb
	# See http://www.redhat.com/archives/rpm-list/2002-July/msg00110.html
	rpmspec -P $(HOME)/rpmbuild/SPECS/tuleap.spec > tuleap-cleaned.spec
	cat tuleap-cleaned.spec | sed 's/\$$RPM_BUILD_ROOT/%{buildroot}/' > tuleap.spec
	cp $(HOME)/rpmbuild/SOURCES/tuleap-$(VERS).tar.gz tuleap_$(VERS).orig.tar.gz
	#spec2deb --format="1.0"
	#spec2deb --format="2.0"
	#spec2deb --format="3.0 (quilt)"
	guidod-spec2deb-5a2bf4c295a6/src/spec2deb/spec2deb.py --format="3.0 (quilt)" tuleap.spec
	tar xzf tuleap_$(VERS).orig.tar.gz
	cd tuleap-$(VERS) && tar xvzf ../tuleap.debian.tar.gz && mv *.postinst *.preinst debian && rm debian/source/options
	dpkg-source -b tuleap-$(VERS)

spec2deb: guidod-spec2deb-5a2bf4c295a6/src/spec2deb/spec2deb.py

guidod-spec2deb-5a2bf4c295a6/src/spec2deb/spec2deb.py: spec2deb-0.4.tar.gz
	tar xvzf spec2deb-0.4.tar.gz

spec2deb-0.4.tar.gz:
	[ -f $@ ] || wget https://bitbucket.org/guidod/spec2deb/get/spec2deb-0.4.tar.gz

$(HOME)/rpmbuild/SOURCES/tuleap-$(VERS).tar.gz:
	@[ -f $@ ] || echo "You have to build rpm first, by running 'make' in tuleap/tools/rpm directory" && exit 2

reallyclean:
	rm -rf guidod-* tuleap* spec2deb*
	
clean:
	rm -rf tuleap*
