// To parse this JSON data, do
//
//     final singleSuraModel = singleSuraModelFromJson(jsonString);

import 'dart:convert';

List<SingleSuraModel> singleSuraModelFromJson(String str) => List<SingleSuraModel>.from(json.decode(str).map((x) => SingleSuraModel.fromJson(x)));

String singleSuraModelToJson(List<SingleSuraModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SingleSuraModel {
  final int id;
  final String surahId;
  final String ayatNo;
  final String arabicVerse;
  final String teleguVerse;
  final dynamic englishVerse;
  final dynamic verseAudio;
  final dynamic path;
  final String uniqueId;
  final String verseRange;
  final DateTime createdAt;
  final DateTime updatedAt;

  SingleSuraModel({
    required this.id,
    required this.surahId,
    required this.ayatNo,
    required this.arabicVerse,
    required this.teleguVerse,
    required this.englishVerse,
    required this.verseAudio,
    required this.path,
    required this.uniqueId,
    required this.verseRange,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SingleSuraModel.fromJson(Map<String, dynamic> json) => SingleSuraModel(
    id: json["id"],
    surahId: json["surah_id"],
    ayatNo: json["ayat_no"],
    arabicVerse: json["arabic_verse"],
    teleguVerse: json["telegu_verse"],
    englishVerse: json["english_verse"],
    verseAudio: json["verse_audio"],
    path: json["path"],
    uniqueId: json["unique_id"],
    verseRange: json["verse_range"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surah_id": surahId,
    "ayat_no": ayatNo,
    "arabic_verse": arabicVerse,
    "telegu_verse": teleguVerse,
    "english_verse": englishVerse,
    "verse_audio": verseAudio,
    "path": path,
    "unique_id": uniqueId,
    "verse_range": verseRange,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
