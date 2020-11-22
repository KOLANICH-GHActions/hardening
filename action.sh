#!/usr/bin/env bash

set -e;

THIS_SCRIPT_DIR=`dirname "${BASH_SOURCE[0]}"`;

for envVar in ${!ACTION_*};
do
	unset $envVar;
done;

for envVar in ${!GITHUB_*};
do
	unset $envVar;
done;

for envVar in ${!INPUT_*};
do
	unset $envVar;
done;

echo "##[group] Replacing http deb server with https one";
	sudo find /etc/apt -name "*.list" -exec sed -i 's%http://deb.debian.org%https://mirrors.edge.kernel.org%g' {} \; ;
	sudo find /etc/apt -name "*.list" -exec sed -i 's%http://azure.archive.ubuntu.com%https://mirrors.edge.kernel.org%g' {} \; ;
	sudo find /etc/apt -name "*.list" -exec sed -i 's%http://dl.google.com%https://dl.google.com%g' {} \; ;
	sudo apt-get update;
	sudo apt-get install -y --reinstall apt-transport-https ca-certificates;
	sudo apt-get update;
echo "##[endgroup]";

echo "##[group] A bit more secure prefs for gpg";
	sudo apt-get install -y gnupg1-curl;

	sudo mkdir -p /root/.gnupg;
	sudo touch /root/.gnupg/gpg.conf;
	sudo chmod -R 700 /root/.gnupg;
	sudo su -c "cat ${THIS_SCRIPT_DIR}/gpg.conf >> /root/.gnupg/gpg.conf";

	mkdir -p ~/.gnupg;
	touch ~/.gnupg/gpg.conf;
	chmod -R 700 ~/.gnupg;
	cat ${THIS_SCRIPT_DIR}/gpg.conf >> ~/.gnupg/gpg.conf;
	chmod -R 700 ~/.gnupg;
echo "##[endgroup]";

echo "##[group] A bit more secure prefs for pip";
	sudo cp ${THIS_SCRIPT_DIR}/pip.conf /etc/;\
echo "##[endgroup]"
