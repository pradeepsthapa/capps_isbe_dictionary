import 'dart:convert';
import 'package:equatable/equatable.dart';

List<BibleVersesModel> bibleVersesModelFromJson(String str) => List<BibleVersesModel>.from(json.decode(str).map((x) => BibleVersesModel.fromJson(x)));
String bibleVersesModelToJson(List<BibleVersesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BibleVersesModel extends Equatable{
  const BibleVersesModel({
    this.bookNumber,
    this.chapter,
    this.text,
    this.verse,
    this.colorIndex,
    this.comment
  });

  final int? bookNumber;
  final int? chapter;
  final String? text;
  final int? verse;
  final int? colorIndex;
  final String? comment;

  factory BibleVersesModel.fromJson(Map<String, dynamic> json) => BibleVersesModel(
      bookNumber: json["book_number"],
      chapter: json["chapter"],
      text: json["text"],
      verse: json["verse"],
      colorIndex: json["color"],
      comment: json["comment"]

  );

  Map<String, dynamic> toJson() => {
    "book_number": bookNumber,
    "chapter": chapter,
    "text": text,
    "verse": verse,
    "color":colorIndex,
    "comment":comment
  };

  BibleVersesModel copyWith({
    int? bookNumber,
    int? chapter,
    String? text,
    int? verse,
    int? colorIndex,
    String? comment,
  }) {
    return BibleVersesModel(
      bookNumber: bookNumber ?? this.bookNumber,
      chapter: chapter ?? this.chapter,
      text: text ?? this.text,
      verse: verse ?? this.verse,
      colorIndex: colorIndex ?? this.colorIndex,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [bookNumber,text,chapter,bookNumber];
}
