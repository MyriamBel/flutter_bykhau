// To parse this JSON data, do
//
//     final articles = articlesFromMap(jsonString);

import 'dart:convert';

List<Articles> articlesFromMap(String str) => List<Articles>.from(json.decode(str).map((x) => Articles.fromMap(x)));

String articlesToMap(List<Articles> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Articles {
  Articles({
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

  factory Articles.fromMap(Map<String, dynamic> json) => Articles(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    photo: json["photo"],
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
    "photo": photo,
    "annotation": annotation,
    "text": text,
    "datetime_creation": datetimeCreation.toIso8601String(),
    "datetime_publication": datetimePublication.toIso8601String(),
    "datetime_edit": datetimeEdit.toIso8601String(),
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
  };
}
