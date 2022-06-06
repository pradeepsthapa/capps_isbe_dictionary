import 'dart:convert';
import 'package:equatable/equatable.dart';

List<DictionaryDefinitionModel> dictionaryDefinitionModelFromJson(String str) => List<DictionaryDefinitionModel>.from(json.decode(str).map((x) => DictionaryDefinitionModel.fromJson(x)));
String dictionaryDefinitionModelToJson(List<DictionaryDefinitionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryDefinitionModel extends Equatable{
  const DictionaryDefinitionModel({
    this.definition,
    this.topic,
  });

  final String? definition;
  final String? topic;

  factory DictionaryDefinitionModel.fromJson(Map<String, dynamic> json) => DictionaryDefinitionModel(
    definition: json["definition"],
    topic: json["topic"],
  );

  Map<String, dynamic> toJson() => {
    "definition": definition,
    "topic": topic,
  };

  @override
  List<Object?> get props => [topic,definition];
}
