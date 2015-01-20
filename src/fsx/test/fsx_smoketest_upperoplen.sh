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

fsx_smoketest_upperoplen () {
	../fsx -vN13 -o1000 -S1 afile 2>&1 > output.txt

	local expected_size="244112"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "c5dc3fb7efe4ff2446cc8652785a2d243f26e22a  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -o1000 -S1 afile
Seed set to 1
extend file size from 0x0 (0) to 0x3a2b4 (238260)
truncating to largest ever: 0x3a2b4
1: TRUNCATE UP     from 0x0 (0) to 0x3a2b4 (238260)
2: MAPWRITE        0x3a0d8 (237784) thru 0x3a2b3 (238259)	(0x1dc (476) bytes)
3: TRUNCATE DOWN   from 0x3a2b4 (238260) to 0x2e344 (189252)
4: TRUNCATE DOWN   from 0x2e344 (189252) to 0x27c14 (162836)
truncating to largest ever: 0x3ee10
5: TRUNCATE UP     from 0x27c14 (162836) to 0x3ee10 (257552)
6: MAPREAD         0x804c (32844) thru 0x805f (32863)	(0x14 (20) bytes)
extend file size from 0x3ee10 (257552) to 0x3fb68 (260968)
truncating to largest ever: 0x3fb68
7: TRUNCATE UP     from 0x3ee10 (257552) to 0x3fb68 (260968)
8: MAPWRITE        0x3f83c (260156) thru 0x3fb67 (260967)	(0x32c (812) bytes)
9: MAPWRITE        0x10e60 (69216) thru 0x10f63 (69475)	(0x104 (260) bytes)
10: MAPWRITE        0x988 (2440) thru 0xcbb (3259)	(0x334 (820) bytes)
11: MAPWRITE        0x355f4 (218612) thru 0x35677 (218743)	(0x84 (132) bytes)
12: TRUNCATE DOWN   from 0x3fb68 (260968) to 0x3b990 (244112)
13: READ            0x2816c (164204) thru 0x2829b (164507)	(0x130 (304) bytes)
14: MAPWRITE        0x20564 (132452) thru 0x206fb (132859)	(0x198 (408) bytes)
15: MAPWRITE        0x2893c (166204) thru 0x28a8b (166539)	(0x150 (336) bytes)
All operations - 15 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_upperoplen () {
	local myindex="${1}"
	local atest="fsx_smoketest_upperoplen"
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
	printf "%s\n" "fsx -vN13 -o1000 -S1 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_upperoplen "1"
exit ${?}
