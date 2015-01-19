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

.PHONY: check

PROVE=prove
OPSYS:=$(shell uname -s)

TSTS=fsx_smoketest_alloplen.sh \
	fsx_smoketest_datasize.sh \
	fsx_smoketest_dirpath.sh \
	fsx_smoketest_flen.sh \
	fsx_smoketest_fsync.sh \
	fsx_smoketest_interactive_later.sh \
	fsx_smoketest_interactive_start.sh \
	fsx_smoketest_logpath.sh \
	fsx_smoketest_mixedcache.sh \
	fsx_smoketest_nomapread.sh \
	fsx_smoketest_nomapwrite.sh \
	fsx_smoketest_nommap.sh \
	fsx_smoketest_openclosechance.sh \
	fsx_smoketest_opnum.sh \
	fsx_smoketest_progressinterval.sh \
	fsx_smoketest_quieter.sh \
	fsx_smoketest_readbdy.sh \
	fsx_smoketest_sanity.sh \
	fsx_smoketest_startingop.sh \
	fsx_smoketest_style.sh \
	fsx_smoketest_truncbdy.sh \
	fsx_smoketest_upperoplen.sh \
	fsx_smoketest_writebdy.sh \
	fsx_smoketest_xmlout.sh

ifeq ($(OPSYS),Darwin)
TSTS+=fsx_smoketest_extented.sh
else
TSTS+=fsx_smoketest_extented_enosys.sh
endif

check: $(TSTS)
	$(PROVE) $^
