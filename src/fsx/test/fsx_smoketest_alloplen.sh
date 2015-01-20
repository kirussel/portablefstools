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

fsx_smoketest_alloplen () {
	../fsx -vN13 -Oo1000 -S1 afile 2>&1 > output.txt

	local expected_size="244112"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "25c72ecfc49be6bcd81640df0fdb878dcad0e7df  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -Oo1000 -S1 afile
Seed set to 1
extend file size from 0x0 (0) to 0x1a844 (108612)
truncating to largest ever: 0x1a844
1: TRUNCATE UP     from 0x0 (0) to 0x1a844 (108612)
2: MAPWRITE        0x1a45c (107612) thru 0x1a843 (108611)	(0x3e8 (1000) bytes)
extend file size from 0x1a844 (108612) to 0x39398 (234392)
truncating to largest ever: 0x39398
3: TRUNCATE UP     from 0x1a844 (108612) to 0x39398 (234392)
4: MAPWRITE        0x38fb0 (233392) thru 0x39397 (234391)	(0x3e8 (1000) bytes)
truncating to largest ever: 0x3cd28
5: TRUNCATE UP     from 0x39398 (234392) to 0x3cd28 (249128)
6: WRITE           0x240ec (147692) thru 0x244d3 (148691)	(0x3e8 (1000) bytes)
7: TRUNCATE DOWN   from 0x3cd28 (249128) to 0x3c0c (15372)
8: READ            0x46c (1132) thru 0x853 (2131)	(0x3e8 (1000) bytes)
extend file size from 0x3c0c (15372) to 0x3f424 (259108)
truncating to largest ever: 0x3f424
9: TRUNCATE UP     from 0x3c0c (15372) to 0x3f424 (259108)
10: MAPWRITE        0x3f03c (258108) thru 0x3f423 (259107)	(0x3e8 (1000) bytes)
11: WRITE           0x75c8 (30152) thru 0x79af (31151)	(0x3e8 (1000) bytes)
12: MAPWRITE        0x10e60 (69216) thru 0x11247 (70215)	(0x3e8 (1000) bytes)
13: MAPWRITE        0x2c61c (181788) thru 0x2ca03 (182787)	(0x3e8 (1000) bytes)
14: WRITE           0x61e4 (25060) thru 0x65cb (26059)	(0x3e8 (1000) bytes)
15: WRITE           0x355f4 (218612) thru 0x359db (219611)	(0x3e8 (1000) bytes)
16: TRUNCATE DOWN   from 0x3f424 (259108) to 0x3b990 (244112)
All operations - 16 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_alloplen () {
	local myindex="${1}"
	local atest="fsx_smoketest_alloplen"
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
	printf "%s\n" "fsx -vN13 -Oo1000 -S1 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_alloplen "1"
exit ${?}
