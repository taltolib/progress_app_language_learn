class CardContentModel {
  final String title;
  final String htmlBody;
  final CardContentType type;


  final String? differenceWord; // поле `word` из таблицы difference


  final List<SpeakingPhrase>? speakingPhrases;

  const CardContentModel({
    required this.title,
    required this.htmlBody,
    required this.type,
    this.differenceWord,
    this.speakingPhrases,
  });
}

enum CardContentType {
  grammar,
  differences,
  thesaurus,
  collocations,
  metaphors,
  speaking,
}

extension CardContentTypeLabel on CardContentType {
  String get label {
    switch (this) {
      case CardContentType.grammar:      return 'Grammar';
      case CardContentType.differences:  return 'Differences';
      case CardContentType.thesaurus:    return 'Thesaurus';
      case CardContentType.collocations: return 'Collocations';
      case CardContentType.metaphors:    return 'Metaphors';
      case CardContentType.speaking:     return 'Speaking';
    }
  }
}

class SpeakingPhrase {
  final int phraseId;
  final String phrase;
  final String? comment;
  final String? synonymsHtml;
  final List<String> translations;
  final List<String> examples;

  const SpeakingPhrase({
    required this.phraseId,
    required this.phrase,
    this.comment,
    this.synonymsHtml,
    required this.translations,
    required this.examples,
  });
}