import 'dart:convert';
import 'package:equatable/equatable.dart';

List<DictionaryWordModel> dictionaryWordModelFromJson(String str) => List<DictionaryWordModel>.from(json.decode(str).map((x) => DictionaryWordModel.fromJson(x)));
String dictionaryWordModelToJson(List<DictionaryWordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryWordModel extends Equatable{
  const DictionaryWordModel({
    this.bookNumber,
    this.chapterNumber,
    this.standardForm,
    this.variation,
    this.verseNumber,
  });

  final int? bookNumber;
  final int? chapterNumber;
  final String? standardForm;
  final String? variation;
  final int? verseNumber;

  factory DictionaryWordModel.fromJson(Map<String, dynamic> json) => DictionaryWordModel(
    bookNumber: json["book_number"],
    chapterNumber: json["chapter_number"],
    standardForm: json["standard_form"],
    variation: json["variation"],
    verseNumber: json["verse_number"],
  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter_number": chapterNumber,
    "standard_form": standardForm,
    "variation": variation,
    "verse_number": verseNumber,
  };

  @override
  List<Object?> get props => [variation,standardForm];
}
