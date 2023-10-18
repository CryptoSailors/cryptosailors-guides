#!/bin/bash
RED='\033[0;31m'        # Red Color
GR='\033[0;32m'         # Green Color
YW='\033[0;33m'         # Yellow Color
PR='\033[0;35m'         # Purpule Color
CY='\033[0;36m'         # Cyan Color
NC='\033[0m'            # No Color
source /home/optimism/.bash_profile >/dev/null 2>&1
check_geth_old_version=$(/home/optimism/go/bin/op-geth --version | awk {'print $3'})
check_op_old_version=$(/home/optimism/go/bin/op-node --version | awk {'print $3'})

nodename="Optimism TestNet RPC Node"

owner="optimism"
gethsrvname="op-geth"
opsrvname="op-node"
home="/home/$owner"

oldgethbinfile="cat /etc/systemd/system/op-geth.service | grep ExecStart | awk {'print $1'} | cut -c 11-"
oldopbinfile="cat /etc/systemd/system/op-node.service | grep ExecStart | awk {'print $1'} | cut -c 11-"

gitgethdir="/home/$owner/optimism-node/op-geth"
gitoptimismdir="/home/$owner/optimism-node/optimism"

gethlatestTag=$(curl -s https://api.github.com/repos/ethereum-optimism/op-geth/releases/latest | grep '.tag_name'|cut -d\" -f4)
optimismlatestTag=$(curl -s https://api.github.com/repos/ethereum-optimism/optimism/releases/latest | grep '.tag_name'|cut -d\" -f4)

token="5517316673:AAHYqs5esddJIT_yIm9MqGi2P_xLua2-qWM"
channel="-849716473"
upd="💜 The $nodename has been updated successfully! 💜"
badupd="‼️ The $nodename wasn't updated! Something goes wrong! Please check the logs ‼️"

echo -e "\e[34m --------------------------------------\e[0m"
echo -e $CY" This script will update $nodename! Do you want to proceed?"
echo ""
echo -n -e $YW" Please choose"$NC $PR"[Y/y"$NC $RED"| N/n]:"$NC
read -r input
if [[ $input != y ]] && [[ $input != Y ]] && [[ $input != yes ]] && [[ $input != Yes ]]; then
echo -e $GR" Bye!Bye!"$NC
exit
fi
        echo -e $YW" Downloading the latest version of the Git repository to build \"geth\" binary file:"$NC
        cd $gitgethdir
	git pull -q 2>&1 | cat
	git checkout $gethlatestTag -q 2>&1 | cat

	echo -e $YW" Build the new \"op-geth\" binary file:"$NC
	go build -o ~/go/bin/op-geth ./cmd/geth

	echo -e $YW" Downloading the latest version of the Git repository to build \"optimism\" binary file:"$NC
        cd $gitoptimismdir
	git pull -q 2>&1 | cat
	git checkout $optimismlatestTag -q 2>&1 | cat

	echo -e $YW "Build the new \"optimism\" binary file:"$NC
	go build -o ~/go/bin/op-node ./op-node/cmd

        check_geth_new_version=$(/home/optimism/go/bin/op-geth --version | awk {'print $3'})
	check_op_new_version=$(/home/optimism/go/bin/op-node --version | awk {'print $3'})

	echo ""
        echo -e " The old version of geth binary file:" ${RED} ${check_geth_old_version} ${NC}
	echo -e " The old version of op binary file:  "   ${RED}    ${check_op_old_version} ${NC}
	echo -e " -------------------------------------"
	echo -e " The new version of geth binary file:" ${GR} ${check_geth_new_version} ${NC}
        echo -e " The new version of op binary file:  "   ${GR}    ${check_op_new_version} ${NC}
        echo ""
        echo -e $CY" Please make sure that they are different"$NC
        echo -n -e $GR" If all look fine, type 'Y/y'"$NC $RED"otherwise press 'N/n': "$NC
        read -r input
if [[ $input != y ]] && [[ $input != Y ]] && [[ $input != yes ]] && [[ $input != Yes ]]; then
        echo -e $YW" Bye!Bye!"$NC
        exit
fi
	echo ""
	echo -e $YW" Restart $gethsrvname service"$NC
	sudo systemctl start $gethsrvname
	sleep 3;

	GETHSTATUS="$(systemctl is-active $gethsrvname)"
if [[ ${GETHSTATUS} = "active" ]]; then
        echo ""
        echo -e $GR" The $gethsrvname service has been restarted sucessfully and running!"$NC
else
	echo ""
	echo -e $RED" !!!!!Something goes wrong because $gethsrvname service is not running!!!"$NC
	echo ""
	echo -e $RED" Please check the log files using the following command:"$NC $PR"sudo journalctl -f -u $gethsrvname"$NC
fi

	echo ""
	echo -e $YW" Restart $opsrvname service"$NC
	sudo systemctl start $opsrvname
	sleep 3;

        OPSTATUS="$(systemctl is-active $opsrvname)"
if      [[ ${OPSTATUS} = "active" ]]; then
	echo ""
        echo -e $GR" The $opsrvname service has been restarted sucessfully and running!"$NC
else
        echo ""
        echo -e $RED" !!!!!Something goes wrong because $opsrvname service is not running!!!"$NC
        echo ""
        echo -e $RED" Please check the log files using the following command:"$NC $PR"sudo journalctl -f -u $opsrvname"$NC
fi

	GETHSTATUS="$(systemctl is-active $gethsrvname)"
	OPSTATUS="$(systemctl is-active $opsrvname)"
if	[ "$GETHSTATUS" == "$OPSTATUS" ]; then
	echo -e ""
	echo -e ""
	echo -e $PR" -----------------------------------------------------------------------"$NC
	echo -e $GR" - Congratilations! The update process has been completed sucessfully! -"$NC
	echo -e $PR" -----------------------------------------------------------------------"$NC
	curl -s --data "text=$upd" --data "chat_id=$channel" 'https://api.telegram.org/bot'$token'/sendMessage' > /dev/null
else
	curl -s --data "text=$badupd" --data "chat_id=$channel" 'https://api.telegram.org/bot'$token'/sendMessage' > /dev/null
	echo -e ""
	echo -e ""
	echo -e $RED" ---------------------------------------------------------------------------------------"$NC
	echo -e $RED" - WOW!WOW!WOW! What is this mother fuck! Something went wrong! Please check the logs! -"$NC
	echo -e $RED" ---------------------------------------------------------------------------------------"$NC
fi
