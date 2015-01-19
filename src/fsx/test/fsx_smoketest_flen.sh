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

fsx_smoketest_flen () {
	../fsx -vN13 -F162140 -S1 afile 2>&1 > output.txt

	local expected_size="136692"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "555fe741647ada38fc8658443cb87e1baf05febc  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -e ./afile.fsxgood -a ! -s .afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Using file afile
command line: ../fsx -vN13 -F162140 -S1 afile
Seed set to 1
extend file size from 0x0 (0) to 0x1b43c (111676)
truncating to largest ever: 0x1b43c
1: TRUNCATE UP     from 0x0 (0) to 0x1b43c (111676)
2: MAPWRITE        0x13520 (79136) thru 0x1b43b (111675)	(0x7f1c (32540) bytes)
3: TRUNCATE DOWN   from 0x1b43c (111676) to 0x8d50 (36176)
4: TRUNCATE UP     from 0x8d50 (36176) to 0xf9d4 (63956)
5: TRUNCATE UP     from 0xf9d4 (63956) to 0x10acc (68300)
6: MAPREAD         0x2610 (9744) thru 0x69f3 (27123)	(0x43e4 (17380) bytes)
extend file size from 0x10acc (68300) to 0x2795c (162140)
truncating to largest ever: 0x2795c
7: TRUNCATE UP     from 0x10acc (68300) to 0x2795c (162140)
8: MAPWRITE        0x25030 (151600) thru 0x2795b (162139)	(0x292c (10540) bytes)
9: MAPWRITE        0x1bd6c (114028) thru 0x23177 (143735)	(0x740c (29708) bytes)
10: MAPWRITE        0x52bc (21180) thru 0x10b7b (68475)	(0xb8c0 (47296) bytes)
11: MAPWRITE        0x19c20 (105504) thru 0x27327 (160551)	(0xd708 (55048) bytes)
12: TRUNCATE DOWN   from 0x2795c (162140) to 0x16260 (90720)
13: READ            0x241c (9244) thru 0xc903 (51459)	(0xa4e8 (42216) bytes)
extend file size from 0x16260 (90720) to 0x215f4 (136692)
14: TRUNCATE UP     from 0x16260 (90720) to 0x215f4 (136692)
15: MAPWRITE        0x17eac (97964) thru 0x215f3 (136691)	(0x9748 (38728) bytes)
16: MAPWRITE        0xcc (204) thru 0xe297 (58007)	(0xe1cc (57804) bytes)
All operations - 16 - completed A-OK!
HEREDOCUMENT
}

run_fsx_smoketest_flen () {
	local myindex="${1}"
	local atest="fsx_smoketest_flen"
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
	printf "%s\n" "fsx -vN13 -F162140 -S1 afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_flen "1"
exit ${?}
