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

fsx_smoketest_openclosechance () {
	../fsx -vN13 -c3 -S2 afile 2>&1 > output.txt

	local expected_size="56948"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "0d197fef6fff76e96a8827a1194d737c403830ef  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Chance of close/open is 1 in 3
Using file afile
command line: ../fsx -vN13 -c3 -S2 afile
Seed set to 2
skipping zero size read
2: WRITE           0x35bbc (220092) thru 0x3ffff (262143)	(0xa444 (42052) bytes) HOLE
		CLOSE/OPEN
extend file size from 0x0 (0) to 0x40000 (262144)
2 close/open
3: MAPWRITE        0x2e5b0 (189872) thru 0x337d7 (210903)	(0x5228 (21032) bytes)
		CLOSE/OPEN
3 close/open
4: MAPREAD         0xe588 (58760) thru 0x1b0cb (110795)	(0xcb44 (52036) bytes)
5: READ            0x11374 (70516) thru 0x13ec3 (81603)	(0x2b50 (11088) bytes)
truncating to largest ever: 0x316ac
6: TRUNCATE DOWN   from 0x40000 (262144) to 0x316ac (202412)
7: READ            0x18ac (6316) thru 0x823f (33343)	(0x6994 (27028) bytes)
8: MAPREAD         0x13e38 (81464) thru 0x1ebf7 (125943)	(0xadc0 (44480) bytes)
extend file size from 0x316ac (202412) to 0x40000 (262144)
truncating to largest ever: 0x40000
9: TRUNCATE UP     from 0x316ac (202412) to 0x40000 (262144)
10: MAPWRITE        0x398ec (235756) thru 0x3ffff (262143)	(0x6714 (26388) bytes)
11: MAPREAD         0x3e624 (255524) thru 0x3ffff (262143)	(0x19dc (6620) bytes)
		CLOSE/OPEN
11 close/open
12: READ            0x919c (37276) thru 0x9b1b (39707)	(0x980 (2432) bytes)
13: MAPWRITE        0x1cdd0 (118224) thru 0x1eb13 (125715)	(0x1d44 (7492) bytes)
14: TRUNCATE DOWN   from 0x40000 (262144) to 0xde74 (56948)
All operations - 14 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_openclosechance () {
	local myindex="${1}"
	local atest="fsx_smoketest_openclosechance"
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
	printf "%s\n" "fsx -vN13 -c3 -S2 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_openclosechance "1"
exit ${?}
