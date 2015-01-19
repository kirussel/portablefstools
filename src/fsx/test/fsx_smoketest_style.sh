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

fsx_smoketest_style () {
	../fsx -vN13 -S1 -s1 afile 2>&1 > output.txt

	local expected_size="224008"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "4a62450f0461db728dd17fee71c0222dfbd13f8c  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -S1 -s1 afile
Seed set to 1
extend file size from 0x0 (0) to 0x40000 (262144)
truncating to largest ever: 0x40000
1: TRUNCATE UP     from 0x0 (0) to 0x40000 (262144)
2: MAPWRITE        0x3a0d8 (237784) thru 0x3ffff (262143)	(0x5f28 (24360) bytes)
3: TRUNCATE DOWN   from 0x40000 (262144) to 0x9850 (38992)
4: TRUNCATE DOWN   from 0x9850 (38992) to 0x1454 (5204)
5: TRUNCATE UP     from 0x1454 (5204) to 0xaffc (45052)
6: MAPREAD         0x56c8 (22216) thru 0x9aab (39595)	(0x43e4 (17380) bytes)
extend file size from 0xaffc (45052) to 0x40000 (262144)
7: TRUNCATE UP     from 0xaffc (45052) to 0x40000 (262144)
8: MAPWRITE        0x3f83c (260156) thru 0x3ffff (262143)	(0x7c4 (1988) bytes)
9: MAPWRITE        0x10e60 (69216) thru 0x1826b (98923)	(0x740c (29708) bytes)
10: MAPWRITE        0x988 (2440) thru 0xc247 (49735)	(0xb8c0 (47296) bytes)
11: MAPWRITE        0x355f4 (218612) thru 0x3ffff (262143)	(0xaa0c (43532) bytes)
12: TRUNCATE DOWN   from 0x40000 (262144) to 0x67b8 (26552)
13: READ            0x3bac (15276) thru 0x67b7 (26551)	(0x2c0c (11276) bytes)
extend file size from 0x67b8 (26552) to 0x29cac (171180)
14: TRUNCATE UP     from 0x67b8 (26552) to 0x29cac (171180)
15: MAPWRITE        0x20564 (132452) thru 0x29cab (171179)	(0x9748 (38728) bytes)
extend file size from 0x29cac (171180) to 0x36b08 (224008)
16: TRUNCATE UP     from 0x29cac (171180) to 0x36b08 (224008)
17: MAPWRITE        0x2893c (166204) thru 0x36b07 (224007)	(0xe1cc (57804) bytes)
All operations - 17 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_style () {
	local myindex="${1}"
	local atest="fsx_smoketest_style"
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
	printf "%s\n" "fsx -vN13 -S1 -s1 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_style "1"
exit ${?}
