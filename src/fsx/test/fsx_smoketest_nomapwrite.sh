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

fsx_smoketest_nomapwrite () {
	../fsx -vN13 -W -S2 afile 2>&1 > output.txt

	local expected_size="118228"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "3a772290abcf826038ab228e75081523929619fd  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
mapped writes DISABLED
Using file afile
command line: ../fsx -vN13 -W -S2 afile
Seed set to 2
truncating to largest ever: 0x2e124
1: TRUNCATE UP     from 0x0 (0) to 0x2e124 (188708)
2: WRITE           0xfc38 (64568) thru 0x111e3 (70115)	(0x15ac (5548) bytes)
3: READ            0x720 (1824) thru 0xe317 (58135)	(0xdbf8 (56312) bytes)
4: READ            0x15564 (87396) thru 0x1b647 (112199)	(0x60e4 (24804) bytes)
5: WRITE           0x3544 (13636) thru 0x12dcb (77259)	(0xf888 (63624) bytes)
6: TRUNCATE DOWN   from 0x2e124 (188708) to 0x16810 (92176)
7: MAPREAD         0x11a74 (72308) thru 0x1680f (92175)	(0x4d9c (19868) bytes)
8: TRUNCATE DOWN   from 0x16810 (92176) to 0xbd0 (3024)
9: MAPREAD         0x91c (2332) thru 0xbcf (3023)	(0x2b4 (692) bytes)
10: READ            0xa80 (2688) thru 0xbcf (3023)	(0x150 (336) bytes)
11: READ            0x8a8 (2216) thru 0xbcf (3023)	(0x328 (808) bytes)
12: WRITE           0x210b4 (135348) thru 0x2406b (147563)	(0x2fb8 (12216) bytes) HOLE
extend file size from 0xbd0 (3024) to 0x2406c (147564)
13: TRUNCATE DOWN   from 0x2406c (147564) to 0x1cdd4 (118228)
All operations - 13 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_nomapwrite () {
	local myindex="${1}"
	local atest="fsx_smoketest_nomapwrite"
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
	printf "%s\n" "fsx -vN13 -W -S2 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_nomapwrite "1"
exit ${?}
