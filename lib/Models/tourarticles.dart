// To parse this JSON data, do
//
//     final tourarticle = tourarticleFromMap(jsonString);

import 'dart:convert';

List<Tourarticle> tourarticleFromMap(String str) => List<Tourarticle>.from(json.decode(str).map((x) => Tourarticle.fromMap(x)));

String tourarticleToMap(List<Tourarticle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Tourarticle {
  Tourarticle({
    this.id,
    this.type,
    this.title,
    this.photo,
    this.annotation,
    this.text,
    this.datetimeCreation,
    this.datetimePublication,
    this.datetimeEdit,
    this.active,
    this.published,
  });

  int id;
  String type;
  String title;
  String photo;
  String annotation;
  String text;
  DateTime datetimeCreation;
  DateTime datetimePublication;
  DateTime datetimeEdit;
  bool active;
  bool published;

  factory Tourarticle.fromMap(Map<String, dynamic> json) => Tourarticle(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    photo: json["photo"] == null ? null : json["photo"],
    annotation: json["annotation"],
    text: json["text"],
    datetimeCreation: DateTime.tryParse(json["datetime_creation"].toString().split(".")[0]),
    datetimePublication: DateTime.tryParse(json["datetime_publication"].toString().split(".")[0]),
    datetimeEdit: DateTime.tryParse(json["datetime_edit"].toString().split(".")[0]),
    active: json["active"] == 0 ? false : true,
    published: json["published"] == 0 ? false : true,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type,
    "title": title,
    "photo": photo == null ? null : photo,
    "annotation": annotation,
    "text": text,
    "datetime_creation": datetimeCreation.toIso8601String(),
    "datetime_publication": datetimePublication.toIso8601String(),
    "datetime_edit": datetimeEdit.toIso8601String(),
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
  };
}
