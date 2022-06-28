import 'dart:convert';

List<SubTourobject> tourobjectFromMap(String str) => List<SubTourobject>.from(json.decode(str).map((x) => SubTourobject.fromMap(x)));

String tourobjectToMap(List<SubTourobject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class SubTourobject {
  SubTourobject({
    this.id,
    this.name,
    this.active,
    this.published,
    this.description,
    this.coordN,
    this.coordE,
    this.address,
  });

  int id;
  String name;
  bool active;
  bool published;
  String description;
  String coordN;
  String coordE;
  String address;

  factory SubTourobject.fromMap(Map<String, dynamic> json) => SubTourobject(
    id: json["id"],
    name: json["name"],
    active: json["active"] == 0 ? false : true,
    published: json["published"] == 0 ? false : true,
    description: json["description"],
    coordN: json["coordN"] == null ? null : json["coordN"],
    coordE: json["coordE"] == null ? null : json["coordE"],
    address: json["address"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
    "description": description,
    "coordN": coordN == null ? null : coordN,
    "coordE": coordE == null ? null : coordE,
    "address": address,
  };
}
