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

fsx_smoketest_writebdy () {
	../fsx -vN13 -S1 -w4096 afile 2>&1 > output.txt

	local expected_size="244112"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "2ef7c7f901e24fee695fa57e243e3b0e4899a2ea  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -S1 -w4096 afile
Seed set to 1
extend file size from 0x0 (0) to 0x3ff28 (261928)
truncating to largest ever: 0x3ff28
1: TRUNCATE UP     from 0x0 (0) to 0x3ff28 (261928)
2: MAPWRITE        0x3a000 (237568) thru 0x3ff27 (261927)	(0x5f28 (24360) bytes)
3: TRUNCATE DOWN   from 0x3ff28 (261928) to 0x2e344 (189252)
4: TRUNCATE DOWN   from 0x2e344 (189252) to 0x27c14 (162836)
5: TRUNCATE UP     from 0x27c14 (162836) to 0x3ee10 (257552)
6: MAPREAD         0x804c (32844) thru 0xc42f (50223)	(0x43e4 (17380) bytes)
extend file size from 0x3ee10 (257552) to 0x3f7c4 (260036)
7: TRUNCATE UP     from 0x3ee10 (257552) to 0x3f7c4 (260036)
8: MAPWRITE        0x3f000 (258048) thru 0x3f7c3 (260035)	(0x7c4 (1988) bytes)
9: MAPWRITE        0x10000 (65536) thru 0x1740b (95243)	(0x740c (29708) bytes)
10: MAPWRITE        0x0 (0) thru 0xb8bf (47295)	(0xb8c0 (47296) bytes)
extend file size from 0x3f7c4 (260036) to 0x3fa0c (260620)
11: TRUNCATE UP     from 0x3f7c4 (260036) to 0x3fa0c (260620)
12: MAPWRITE        0x35000 (217088) thru 0x3fa0b (260619)	(0xaa0c (43532) bytes)
13: TRUNCATE DOWN   from 0x3fa0c (260620) to 0x3b990 (244112)
14: READ            0x2816c (164204) thru 0x32653 (206419)	(0xa4e8 (42216) bytes)
15: MAPWRITE        0x20000 (131072) thru 0x29747 (169799)	(0x9748 (38728) bytes)
16: MAPWRITE        0x28000 (163840) thru 0x361cb (221643)	(0xe1cc (57804) bytes)
All operations - 16 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_writebdy () {
	local myindex="${1}"
	local atest="fsx_smoketest_writebdy"
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
	printf "%s\n" "fsx -vN13 -S1 -w4096 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_writebdy "1"
exit ${?}
