class CardContentModel {
  final String title;        // заголовок слова или темы
  final String htmlBody;     // HTML из БД (grammar, thesaurus, collocation, metaphor, difference)
  final CardContentType type;

  // Только для Differences
  final String? differenceWord; // поле `word` из таблицы difference

  // Только для Speaking
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

/// Модель для Speaking — каждая фраза с переводами и примерами
class SpeakingPhrase {
  final int phraseId;
  final String phrase;          // e.g. "take sb aback"
  final String? comment;        // e.g. "[informal]"
  final String? synonymsHtml;   // HTML synonyms
  final List<String> translations; // узбекские переводы
  final List<String> examples;    // примеры предложений

  const SpeakingPhrase({
    required this.phraseId,
    required this.phrase,
    this.comment,
    this.synonymsHtml,
    required this.translations,
    required this.examples,
  });
}