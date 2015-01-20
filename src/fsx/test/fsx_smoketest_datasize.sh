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

fsx_smoketest_datasize () {
	../fsx -vN13 -T1 -S2 afile 2>&1 > output.txt

	local expected_size="56947"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "3b259901bede85450f8303ba845b00758747dbbc  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -T1 -S2 afile
Seed set to 2
skipping zero size read
2(2): WRITE           0x35bbc (220092) thru 0x3ffff (262143)	(0xa444 (42052) bytes) HOLE
extend file size from 0x0 (0) to 0x40000 (262144)
3(3): MAPWRITE        0x2e5b0 (189872) thru 0x337d7 (210903)	(0x5228 (21032) bytes)
4(4): MAPREAD         0xe589 (58761) thru 0x1b0cb (110795)	(0xcb43 (52035) bytes)
5(5): READ            0x11377 (70519) thru 0x13ec6 (81606)	(0x2b50 (11088) bytes)
truncating to largest ever: 0x316aa
6(6): TRUNCATE DOWN   from 0x40000 (262144) to 0x316aa (202410)
7(7): READ            0x5603 (22019) thru 0xbf93 (49043)	(0x6991 (27025) bytes)
8(8): MAPREAD         0x17036 (94262) thru 0x21df2 (138738)	(0xadbd (44477) bytes)
extend file size from 0x316aa (202410) to 0x40000 (262144)
truncating to largest ever: 0x40000
9(9): TRUNCATE UP     from 0x316aa (202410) to 0x40000 (262144)
10(10): MAPWRITE        0x398ec (235756) thru 0x3ffff (262143)	(0x6714 (26388) bytes)
11(11): MAPREAD         0x3e627 (255527) thru 0x3ffff (262143)	(0x19d9 (6617) bytes)
12(12): READ            0x919d (37277) thru 0x9b1b (39707)	(0x97f (2431) bytes)
13(13): MAPWRITE        0x1cdd2 (118226) thru 0x1eb12 (125714)	(0x1d41 (7489) bytes)
14(14): TRUNCATE DOWN   from 0x40000 (262144) to 0xde73 (56947)
All operations - 14 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_datasize () {
	local myindex="${1}"
	local atest="fsx_smoketest_datasize"
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
	printf "%s\n" "fsx -vN13 -T1 -S2 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_datasize "1"
exit ${?}
