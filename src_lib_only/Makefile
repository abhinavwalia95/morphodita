# This file is part of MorphoDiTa <http://github.com/ufal/morphodita/>.
#
# Copyright 2015 Institute of Formal and Applied Linguistics, Faculty of
# Mathematics and Physics, Charles University in Prague, Czech Republic.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

include ../src/Makefile.builtem
include ../src/Makefile.include

MERGE=$(call exe,merge_sources/merge_sources)

morphodita.cpp: $(MERGE) force
	@$(call echo,>$@,// This file is part of MorphoDiTa <http://github.com/ufal/morphodita/>.)
	@$(call echo,>>$@,//)
	@$(call echo,>>$@,// This file is a bundle of all sources and headers of MorphoDiTa library.)
	@$(call echo,>>$@,// Comments and copyrights of all individual files are kept.)
	$(call platform_name,$(MERGE)) ufal::morphodita ../src/ $(patsubst %,%.cpp,$(MORPHODITA_OBJECTS)) >>$@

$(MERGE):$(call exe,%):$$(call obj,%)
	$(call link_exe,$@,$^,$(call win_subsystem,console))

.PHONY: force
force:

.PHONY: clean
clean:
	@$(call rm,.build morphodita.cpp $(call all_exe,$(MERGE)))
