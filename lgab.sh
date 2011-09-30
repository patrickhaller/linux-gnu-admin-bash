#!/bin/bash
# little green advanced bash

lgab_is_process_pid() { ps -p $1  2>&1 >/dev/null ; }
lgab_is_process_pidfile() { lgab_is_process_pid $(< "$1" ) ; }
lgab_is_process_command() {
	cmd=$( basename "$1" )
	ps -C $cmd 2>&1 >/dev/null
}
lgab_is_process() {
	[[ $1 =~ '^[0-9]*$' ]] && { lgab_is_process_pid $1 ; return $?; }
	[[ -x $1 ]] && { lgab_is_process_command $1 ; return $?; }
	[[ -e $1 ]] && { lgab_is_process_pidfile $1 ; return $?; }
	lgab_is_process_command $1 
	return $?
}

lgab_test_run() {
	res=$( $1 )
	ret=$?
	[[ "$res" = "$2" && $ret = "$3" ]] && { echo "$1 OK"; return ;}
	echo "$1 failed ..."
	return
}

lgab_test_suite() {
	tmpf="/tmp/lgab-pid-test"
	echo 1 > $tmpf
	lgab_test_run 'lgab_is_process "bash"' "" 0
	lgab_test_run 'lgab_is_process 1' "" 0
	lgab_test_run "lgab_is_process $tmpf" "" 0
	rm -f $tmpf
}

[[ "${BASH_ARGV[0]}" =~ "lgab_test" ]] && lgab_test_suite
