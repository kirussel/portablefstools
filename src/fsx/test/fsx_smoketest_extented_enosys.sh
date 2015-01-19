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

fsx_smoketest_extented_enosys () {
	../fsx -vN13 -S1 -e afile 2>&1 > output.txt || true

	local expected_size="0"
	eval $(stat -s afile)
	[ ${st_size} -eq "${expected_size}" ]

	echo "da39a3ee5e6b4b0d3255bfef95601890afd80709  afile" | shasum -c -
	[ -s ./afile.fsxlog ]
	[ -s ./afile.fsxgood ]

	diff output.txt - 2>&1 <<HEREDOCUMENT
Writing into extended attribute
Using file afile
command line: ../fsx -vN13 -S1 -e afile
Seed set to 1
skipping zero size read
skipping zero size read
skipping zero size read
4: WRITE           0x0 (0) thru 0x713 (1811)	(0x714 (1812) bytes) EXTEND
extend file size from 0x0 (0) to 0x714 (1812)
ea_dowrite: setxattr: Function not implemented
Correct content saved for comparison
(maybe hexdump "afile" vs "afile.fsxgood")
Seed was set to 1
HEREDOCUMENT
}

run_fsx_smoketest_extented_enosys () {
	local myindex="${1}"
	local atest="fsx_smoketest_extented_enosys"
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
	printf "%s\n" "fsx -vN13 -S1 -e afile"
	return 0
}

printf "%d..%d\n" "1" "1"
run_fsx_smoketest_extented_enosys "1"
exit ${?}
