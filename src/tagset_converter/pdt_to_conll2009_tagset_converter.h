// This file is part of MorphoDiTa <http://github.com/ufal/morphodita/>.
//
// Copyright 2015 Institute of Formal and Applied Linguistics, Faculty of
// Mathematics and Physics, Charles University in Prague, Czech Republic.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#pragma once

#include "common.h"
#include "tagset_converter.h"

namespace ufal {
namespace morphodita {

class pdt_to_conll2009_tagset_converter : public tagset_converter {
 public:
  virtual void convert(tagged_lemma& tagged_lemma) const override;
  virtual void convert_analyzed(vector<tagged_lemma>& tagged_lemmas) const override;
  virtual void convert_generated(vector<tagged_lemma_forms>& forms) const override;

 private:
  inline void convert_tag(const string& lemma, string& tag) const;
  inline bool convert_lemma(string& lemma) const;
};

} // namespace morphodita
} // namespace ufal
