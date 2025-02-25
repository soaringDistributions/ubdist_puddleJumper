
# CAUTION: ATTENTION: Do NOT unnecessarily download infrastructure, etc, exclusively, as opposed to updating, from external sources. Changes to the underlying Debian dist/OS (eg. python2.7 'deprecation') breaks such very useful tools as gEDA - maintaining a CI pipeline originating from ubdist/OS or ubdist_dummy/OS with manually made changes to the 'disk image', offline conversion to live ISO/USB, WSL rootfs, etc, is a very important feature of ubDistBuild/ubdist/OS, which absolutely should NOT be broken.

_custom() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	
	_start
	
	
	_chroot bash -c 'echo root:$(cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc a-zA-Z0-9 2> /dev/null | head -c 12 2> /dev/null) | chpasswd'
	_chroot bash -c 'echo root:$(cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc a-zA-Z0-9 2> /dev/null | head -c 32 2> /dev/null) | chpasswd'
	
	_chroot bash -c 'echo user:$(cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc a-zA-Z0-9 2> /dev/null | head -c 12 2> /dev/null) | chpasswd'
	_chroot bash -c 'echo user:$(cat /dev/urandom 2> /dev/null | base64 2> /dev/null | tr -dc a-zA-Z0-9 2> /dev/null | head -c 32 2> /dev/null) | chpasswd'
	
	
	echo '###################################################################################################'
	echo '###################################################################################################'
	echo '###################################################################################################'
	
	
	
	_custom_kernel_server
	
	
	
	echo '###################################################################################################'
	echo '###################################################################################################'
	echo '###################################################################################################'
	


	! _openChRoot && _messageFAIL
	
	#sudo -n apt-get -y install vsftpd
	if ! sudo -n ls "$globalVirtFS"/home/user/core/infrastructure/puddleJumper
	then
		_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'infrastructure' ; cd /home/user/core/'infrastructure' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest clone --recursive --depth 1 git@github.com:'mirage335-gizmos'/'puddleJumper'.git'
		if ! sudo -n ls "$globalVirtFS"/home/user/core/infrastructure/puddleJumper
		then
			_messagePlain_bad 'bad: FAIL: missing: '/home/user/core/infrastructure/puddleJumper
			_messageFAIL
			_stop 1
			return 1
		fi
	fi
	_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'cd /home/user/core/infrastructure/puddleJumper ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest pull'

	_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/puddleJumper ; ./ubiquitous_bash.sh _install'
	
	! _closeChRoot && _messageFAIL
	
	
	
	echo '###################################################################################################'
	echo '###################################################################################################'
	echo '###################################################################################################'

	
		
	! _openChRoot && _messageFAIL
	

	custom_hostname="puddleJumper"
	
	echo "$custom_hostname" | sudo -n tee "$globalVirtFS"/etc/hostname > /dev/null 2>&1
	cat << CZXWXcRMTo8EmM8i4d | sudo -n tee "$globalVirtFS"/etc/hosts > /dev/null 2>&1
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters

127.0.1.1	$custom_hostname

CZXWXcRMTo8EmM8i4d

	_chroot hostname "$custom_hostname"
	
	
	! _closeChRoot && _messageFAIL


	
	echo '###################################################################################################'
	echo '###################################################################################################'
	echo '###################################################################################################'
	
	! _openChRoot && _messagePlain_bad 'fail: openChroot' && _messageFAIL

	sudo -n cp -a -f /home/user/core/installations/pumpCompanion.exe "$globalVirtFS"/home/user/core/installations/
	_wget_githubRelease "mirage335-gizmos/pumpCompanion" "internal" "pumpCompanion.exe"
	[[ $(wc -c pumpCompanion.exe | cut -f1 -d\  | tr -dc '0-9') -lt 1000000 ]] && rm -f pumpCompanion.exe
	sudo -n mv -f pumpCompanion.exe "$globalVirtFS"/home/user/core/installations/
	
	sudo -n cp -a -f /home/user/core/installations/extIface.exe "$globalVirtFS"/home/user/core/installations/
	_wget_githubRelease "mirage335-colossus/extendedInterface" "internal" "extIface.exe"
	[[ $(wc -c extIface.exe | cut -f1 -d\  | tr -dc '0-9') -lt 1000000 ]] && rm -f extIface.exe
	sudo -n mv -f extIface.exe "$globalVirtFS"/home/user/core/installations/
	
	sudo -n cp -a -f /home/user/core/installations/ubDistBuild.exe "$globalVirtFS"/home/user/core/installations/
	_wget_githubRelease "soaringDistributions/ubDistBuild" "internal" "ubDistBuild.exe"
	[[ $(wc -c ubDistBuild.exe | cut -f1 -d\  | tr -dc '0-9') -lt 1000000 ]] && rm -f ubDistBuild.exe
	sudo -n mv -f ubDistBuild.exe "$globalVirtFS"/home/user/core/installations/
	
	! _closeChRoot && _messagePlain_bad 'fail: closeChroot' && _messageFAIL
	
	echo '###################################################################################################'
	echo '###################################################################################################'
	echo '###################################################################################################'
	
	
	
	! _openChRoot && _messagePlain_bad 'fail: openChroot' && _messageFAIL
	
	# DANGER: Though it might be nice to have a copy of Docker images used by researchEngine, it is NOT acceptable to have any unnecessary network services on a puddleJumper .
	#_messageNormal '***** ***** ***** ***** ***** custom: researchEngine'
	#_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/ubiquitous_bash ; ./ubiquitous_bash.sh _gitBest pull ; chmod 755 ./ubiquitous_bash.sh ; ./ubiquitous_bash.sh _setup_researchEngine'

	# ATTENTION: Ensures a copy of important LLM models is available from puddleJumper . These may be extracted:
	#ollama show Llama-augment --modelfile
	_messageNormal '***** ***** ***** ***** ***** custom: researchEngine: AI models'
	_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/ubiquitous_bash ; ./ubiquitous_bash.sh _gitBest pull ; chmod 755 ./ubiquitous_bash.sh ; ./ubiquitous_bash.sh _setup_researchEngine _setup_models_extra-user'

	
	_messageNormal '***** ***** ***** ***** ***** custom: iconArt'
	_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/iconArt ; ./ubiquitous_bash.sh _gitBest pull ; chmod 755 ./ubiquitous_bash.sh ; ./ubiquitous_bash.sh _fetch_iconArt'


	! _closeChRoot && _messagePlain_bad 'fail: closeChroot' && _messageFAIL
}

_custom-expand() {
	local currentExitStatus
	currentExitStatus="0"
	
	_messageNormal '_custom-expand: dd'

	# ATTENTION: Expand ONLY the additional amount needed for custom additions . This is APPENDED .
	#! dd if=/dev/zero bs=1M count=25000 >> "$scriptLocal"/vm.img && _messageFAIL
	! dd if=/dev/zero bs=1M count=35000 >> "$scriptLocal"/vm.img && _messageFAIL

	# Alternatively, it may be possible, but STRONGLY DISCOURAGED, to pad the file to a size. This, however, assumes the upstream 'ubdist/OS', etc, has not unexpectedly grown larger, which is still a VERY BAD assumption.
	# https://unix.stackexchange.com/questions/196715/how-to-pad-a-file-to-a-desired-size
	
	
	_messageNormal '_custom-expand: growpart'
	! _openLoop && _messagePlain_bad 'fail: openLoop' && _messageFAIL
	
	export ubVirtPlatform="x64-efi"
	#_determine_rawFileRootPartition
	
	export ubVirtImagePartition="p5"
	
	local current_imagedev=$(cat "$scriptLocal"/imagedev)
	local current_rootpart=$(echo "$ubVirtImagePartition" | tr -dc '0-9')
	
	! _messagePlain_probe_cmd sudo -n growpart "$current_imagedev" "$current_rootpart" && _messageFAIL
	
	unset ubVirtPlatform
	unset ubVirtImagePartition
	
	! _closeLoop && _messagePlain_bad 'fail: closeLoop' && _messageFAIL
	
	_messageNormal '_custom-expand: btrfs resize'
	! _openChRoot && _messagePlain_bad 'fail: openChRoot' && _messageFAIL
	
	
	! _messagePlain_probe_cmd _chroot btrfs filesystem resize max / && _messageFAIL
	
	
	! _closeChRoot && _messagePlain_bad 'fail: closeChRoot' && _messageFAIL
	
	return 0
}

_custom-repo() {
	_git-custom-repo variant org repo
	
	_git-custom-repo variant org repo_bundle
}


_git-custom-repo() {
	! _openChRoot && _messageFAIL
	
	export INPUT_GITHUB_TOKEN="$GH_TOKEN"
	
	_chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user bash -c 'mkdir -p /home/user/core/'"$1"' ; cd /home/user/core/'"$1"' ; /home/user/ubDistBuild/ubiquitous_bash.sh _gitBest clone --recursive --depth 1 git@github.com:'"$2"'/'"$3"'.git'
	if ! sudo -n ls "$globalVirtFS"/home/user/core/"$1"/"$3"
	then
		_messagePlain_bad 'bad: FAIL: missing: '/home/user/core/"$1"/"$3"
		_messageFAIL
		_stop 1
		return 1
	fi
	
	! _closeChRoot && _messageFAIL
}

