export LIMIT="5020"
export PRIVILEGED="true"
export WORKING_HOME_DIRECTORY="/export/tgrid/TestingGrid-latest/bin"

if [ -f ${WORKING_HOME_DIRECTORY}/break.bin ]
then
	echo breaking
	exit 5
fi

function privilegedActions {
	echo Executing priviliged bootstrap actions in PID $$
	if [ ! -z $LIMIT ] 
	then
		echo setting hard and soft open files ulimit to $LIMIT
#		ulimit -Hn $LIMIT
		ulimit -Sn $LIMIT
	fi
	if [ -f ${WORKING_HOME_DIRECTORY}/privileged-script.sh ]
	then
		echo executing privileged script
		source ${WORKING_HOME_DIRECTORY}/privileged-script.sh
	fi
}

if [ ! -z $PRIVILEGED_BOOTSTRAP_USER ]
then
	echo In second phase of privileged bootstrap in PID $$
	# phase 2
	privilegedActions
	targetUser="$PRIVILEGED_BOOTSTRAP_USER"
	export PRIVILEGED_BOOTSTRAP_USER=
	sudo -s -u $targetUser "export PRIVILEGED_MARKER=on;${WORKING_HOME_DIRECTORY}/test.sh"
	exit 0
else
	if [ ! -z $PRIVILEGED_MARKER ]
	then
		# finished privileged phase of bootstrap
		echo finished privileged phase of bootstrap in PID $$
	else

		if [ ! -z $LIMIT -o -f "privileged-script.sh" ] 
		then
			# phase 1 - begin priviliged bootstrap process
			echo In first phase of privileged bootstrap in PID $$
			if [ `whoami` = "root" ] 
			then
				# just run the privileged actions now
				priviligedActions
			else	
				# verify passwordless sudo privileges for current user
				sudo -n ls > /dev/null || exit 1
				export PRIVILEGED_BOOTSTRAP_USER=`whoami`
				sudo -E ${WORKING_HOME_DIRECTORY}/test.sh
				exit 0
			fi
		else
			echo Standard bootstrap process will be used
		fi
	fi

fi

# phase 3
echo Beginning standard bootstrap process in PID $$
ulimit -n
