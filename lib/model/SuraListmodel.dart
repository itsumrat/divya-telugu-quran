// To parse this JSON data, do
//
//     final suraListModel = suraListModelFromJson(jsonString);

import 'dart:convert';

SuraListModel suraListModelFromJson(String str) => SuraListModel.fromJson(json.decode(str));

String suraListModelToJson(SuraListModel data) => json.encode(data.toJson());

class SuraListModel {
  final List<Datum> data;

  SuraListModel({
    required this.data,
  });

  factory SuraListModel.fromJson(Map<String, dynamic> json) => SuraListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  final int id;
  final String surahNumber;
  final String englishName;
  final String arabicName;
  final String teleguName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Datum({
    required this.id,
    required this.surahNumber,
    required this.englishName,
    required this.arabicName,
    required this.teleguName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    surahNumber: json["surah_number"],
    englishName: json["english_name"],
    arabicName: json["arabic_name"],
    teleguName: json["telegu_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surah_number": surahNumber,
    "english_name": englishName,
    "arabic_name": arabicName,
    "telegu_name": teleguName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
