// This file is part of MorphoDiTa.
//
// Copyright 2013 by Institute of Formal and Applied Linguistics, Faculty of
// Mathematics and Physics, Charles University in Prague, Czech Republic.
//
// MorphoDiTa is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// MorphoDiTa is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with MorphoDiTa.  If not, see <http://www.gnu.org/licenses/>.

%{
#include "morphodita.h"
using namespace ufal::morphodita;
%}

%include "std_string.i"
%include "std_vector.i"

%template(Forms) std::vector<std::string>;
typedef std::vector<std::string> Forms;

%rename(TaggedForm) tagged_form;
struct tagged_form {
  std::string form;
  std::string tag;
};
%template(TaggedForms) std::vector<tagged_form>;
typedef std::vector<tagged_form> TaggedForms;

%rename(TaggedLemma) tagged_lemma;
struct tagged_lemma {
  std::string lemma;
  std::string tag;
};
%template(TaggedLemmas) std::vector<tagged_lemma>;
typedef std::vector<tagged_lemma> TaggedLemmas;

%rename(TaggedLemmaForms) tagged_lemma_forms;
struct tagged_lemma_forms {
  std::string lemma;
  std::vector<tagged_form> forms;
};
%template(TaggedLemmasForms) std::vector<tagged_lemma_forms>;
typedef std::vector<tagged_lemma_forms> TaggedLemmasForms;

%rename(TokenRange) token_range;
struct token_range {
  size_t start;
  size_t length;
};
%template(TokenRanges) std::vector<token_range>;
typedef std::vector<token_range> TokenTanges;

%rename(Tokenizer) tokenizer;
%nodefaultctor tokenizer;
class tokenizer {
 public:
  virtual ~tokenizer() {}

  %extend {
    %rename(setText) set_text;
    void set_text(const char* text) {
      $self->set_text(text, true);
    }

    %rename(nextSentence) next_sentence;
    bool next_sentence(std::vector<std::string>* forms, std::vector<token_range>* tokens) {
      if (!forms) return $self->next_sentence(NULL, tokens);

      std::vector<string_piece> string_pieces;
      bool result = $self->next_sentence(&string_pieces, tokens);
      forms->resize(string_pieces.size());
      for (unsigned i = 0; i < string_pieces.size(); i++)
        forms->operator[](i).assign(string_pieces[i].str, string_pieces[i].len);
      return result;
    }
  }

  %rename(newVerticalTokenizer) new_vertical_tokenizer;
  %newobject new_vertical_tokenizer;
  static tokenizer* new_vertical_tokenizer();

  %rename(newCzechTokenizer) new_czech_tokenizer;
  %newobject new_czech_tokenizer;
  static tokenizer* new_czech_tokenizer();

  %rename(newEnglishTokenizer) new_english_tokenizer;
  %newobject new_english_tokenizer;
  static tokenizer* new_english_tokenizer();
};

%rename(Morpho) morpho;
%nodefaultctor morpho;
class morpho {
 public:
  virtual ~morpho() {}

  %newobject load;
  static morpho* load(const char* fname);

  enum { NO_GUESSER = 0, GUESSER = 1 };
  typedef int guesser_mode;

  virtual int analyze(const char* form, guesser_mode guesser, std::vector<tagged_lemma>& lemmas) const;

  virtual int generate(const char* lemma, const char* tag_wildcard, guesser_mode guesser, std::vector<tagged_lemma_forms>& forms) const;

  %extend {
    %rename(rawLemma) raw_lemma;
    std::string raw_lemma(const char* lemma) const {
      return std::string(lemma, $self->raw_lemma_len(lemma));
    }

    %rename(lemmaId) lemma_id;
    std::string lemma_id(const char* lemma) const {
      return std::string(lemma, $self->lemma_id_len(lemma));
    }
  }

  %rename(newTokenizer) new_tokenizer;
  %newobject new_tokenizer;
  virtual tokenizer* new_tokenizer() const;
};

%rename(Tagger) tagger;
%nodefaultctor tagger;
class tagger {
 public:
  virtual ~tagger() {}

  %newobject load;
  static tagger* load(const char* fname);

  %rename(getMorpho) get_morpho;
  virtual const morpho* get_morpho() const;

  %extend {
    void tag(const std::vector<std::string>& forms, std::vector<tagged_lemma>& tags) const {
      std::vector<string_piece> string_pieces;
      string_pieces.reserve(forms.size());
      for (auto&& form : forms)
        string_pieces.emplace_back(form);
      $self->tag(string_pieces, tags);
    }
  }

  %rename(newTokenizer) new_tokenizer;
  %newobject new_tokenizer;
  tokenizer* new_tokenizer() const;
};

%rename(TagsetConverter) tagset_converter;
%nodefaultctor tagset_converter;
class tagset_converter {
 public:
  virtual ~tagset_converter() {}

  virtual void convert(tagged_lemma& tagged_lemma) const;
  %rename(convertAnalyzed) convert_analyzed;
  virtual void convert_analyzed(std::vector<tagged_lemma>& tagged_lemmas) const;
  %rename(convertGenerated) convert_generated;
  virtual void convert_generated(std::vector<tagged_lemma_forms>& forms) const;

  %rename(newIdentityConverter) new_identity_converter;
  %newobject new_identity_converter;
  static tagset_converter* new_identity_converter();

  %rename(newPdtToConll2009Converter) new_pdt_to_conll2009_converter;
  %newobject new_pdt_to_conll2009_converter;
  static tagset_converter* new_pdt_to_conll2009_converter();
};