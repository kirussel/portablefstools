#!/bin/sh
#
# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

fsx_smoketest_progressinterval () {
	../fsx -p2 -N13 -S1 afile 2>&1 > output.txt

	local expected_size="244112"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "f37dbc993e71e59f04680831c4e12cd3f2f7ebd8  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -p2 -N13 -S1 afile
Seed set to 1
truncating to largest ever: 0x40000
2: MAPWRITE        0x3a0d8 (237784) thru 0x3ffff (262143)	(0x5f28 (24360) bytes)
4: TRUNCATE DOWN   from 0x2e344 (189252) to 0x27c14 (162836)
6: MAPREAD         0x804c (32844) thru 0xc42f (50223)	(0x43e4 (17380) bytes)
8: MAPWRITE        0x3f83c (260156) thru 0x3ffff (262143)	(0x7c4 (1988) bytes)
10: MAPWRITE        0x988 (2440) thru 0xc247 (49735)	(0xb8c0 (47296) bytes)
12: TRUNCATE DOWN   from 0x40000 (262144) to 0x3b990 (244112)
14: MAPWRITE        0x20564 (132452) thru 0x29cab (171179)	(0x9748 (38728) bytes)
All operations - 15 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_progressinterval () {
	local myindex="${1}"
	local atest="fsx_smoketest_progressinterval"
	mkdir -p tmp
	rm -f afile afile.* tmp/afile.*
	(
		set -ue
		${atest}
	)
	if [ "0" -ne "${?}" ] ; then
		printf "not "
	fi

	printf "ok %d - %s " "${myindex}" "${atest}"
	printf "%s\n" "fsx -p2 -N13 -S1 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_progressinterval "1"
exit ${?}
