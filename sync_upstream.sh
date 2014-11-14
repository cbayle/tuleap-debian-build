#
# Docs :
#
# http://stackoverflow.com/questions/7244321/how-to-update-github-forked-repository
# https://guides.github.com/introduction/flow/index.html
# http://stackoverflow.com/questions/2003505/delete-a-git-branch-both-locally-and-remotely
#
# Submodules are :
TULEAP="https://github.com/cbayle/tuleap.git"
UPSTULEAP="https://github.com/Enalean/tuleap.git"

FORGEUPG="https://github.com/vaceletm/ForgeUpgrade.git"
#
JPGRAPH="https://github.com/cbayle/jpgraph-tuleap.git"
#  cloned from
UPSJPGRAPH="gitolite@tuleap.net:tuleap/deps/tuleap/jpgraph-tuleap.git"
#
MAILMAN="https://github.com/cbayle/mailman-tuleap.git"
#  cloned from
UPSMAILMAN="gitolite@tuleap.net:tuleap/deps/tuleap/mailman-tuleap.git"
#
VIEWVC="https://github.com/cbayle/viewvc-tuleap.git"
#  cloned from
UPSVIEWVC="gitolite@tuleap.net:tuleap/deps/tuleap/viewvc-tuleap.git"
#
OPENFIREPLUGIN="https://github.com/cbayle/openfire-tuleap-plugins.git"
#  cloned from
UPSOPENFIREPLUGIN="gitolite@tuleap.net:tuleap/deps/tuleap/openfire-tuleap-plugins.git"
#
MAILMBOX="https://alioth.debian.org/anonscm/git/pkg-php/php-mail-mbox.git"
LESSC="https://alioth.debian.org/anonscm/git/collab-maint/less.js.git"
#
# see also https://github.com/less/less.js.git
# see also https://www.npmjs.org/package/npm2debian https://github.com/arikon/npm2debian

fetch_upstream(){
	upstream_dir=$1
	upstream_url=$2
	(cd $1
	git remote -v | grep -q 'upstream	'
	if [ $? -eq 0 ]
	then
		echo "Upstream already added"
	else
		git remote add upstream $upstream_url
	fi
	git fetch upstream)
}

sync_tuleap(){
	fetch_upstream tuleap $TULEAP
}

sync_jpgraph-tuleap(){
	fetch_upstream jpgraph-tuleap $UPSJPGRAPH
}

sync_mailman-tuleap(){
	fetch_upstream mailman-tuleap $UPSMAILMAN
}

sync_viewvc-tuleap(){
	fetch_upstream viewvc-tuleap $UPSVIEWVC
}

sync_openfire-tuleap-plugins(){
	fetch_upstream openfire-tuleap-plugins $UPSOPENFIREPLUGIN
}

sync(){
for submodule in tuleap jpgraph-tuleap mailman-tuleap viewvc-tuleap openfire-tuleap-plugins
do
	sync_$submodule
done
}

rebase(){
for submodule in tuleap jpgraph-tuleap mailman-tuleap viewvc-tuleap openfire-tuleap-plugins
do
	(cd $submodule
	git rebase upstream/master)
done
}

merge(){
for submodule in tuleap jpgraph-tuleap mailman-tuleap viewvc-tuleap openfire-tuleap-plugins
do
	(cd $submodule
	git merge upstream/master)
done
}

list(){
for submodule in tuleap jpgraph-tuleap mailman-tuleap viewvc-tuleap openfire-tuleap-plugins forgeupgrade php-mail-mbox
do
	(cd $submodule
	git remote -v)
done
}

merge
