class WordCard {
  final int id;
  final String word;
  final String? body;

  WordCard({required this.id, required this.word, this.body});
}

class WordDetail {
  final int id;
  final String word;
  final String? grammarBody;
  final String? differenceBody;
  final String? thesaurusBody;
  final String? collocationBody;
  final String? metaphorBody;
  final String? wordRu;
  final String? wordUz;

  WordDetail({
    required this.id,
    required this.word,
    this.grammarBody,
    this.differenceBody,
    this.thesaurusBody,
    this.collocationBody,
    this.metaphorBody,
    this.wordRu,
    this.wordUz,
  });
}

class SearchResult {
  final int id;
  final String word;
  final String? wordRu;
  final String? wordUz;
  final String? pronunciation;


  SearchResult({
    required this.id,
    required this.word,
    this.wordRu,
    this.wordUz,
    this.pronunciation,
  });
}

class PhraseItem {
  final int id;
  final String phrase;
  final List<String> translations;
  final List<String> examples;

  PhraseItem({
    required this.id,
    required this.phrase,
    required this.translations,
    required this.examples,
  });
}
