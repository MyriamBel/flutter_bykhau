// To parse this JSON data, do
//
//     final tourobject = tourobjectFromMap(jsonString);

import 'dart:convert';


List<Tourobject> tourobjectFromMap(String str) => List<Tourobject>.from(json.decode(str).map((x) => Tourobject.fromMap(x)));

String tourobjectToMap(List<Tourobject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Tourobject {
  Tourobject({
    this.id,
    this.category,
    this.photos,
    this.phones,
    this.emails,
    this.links,
    this.name,
    this.active,
    this.published,
    this.description,
    this.coordN,
    this.coordE,
    this.address,
  });

  int id;
  List<Category> category;
  List<Photo> photos;
  List<TourobjectPhone> phones;
  List<TourobjectEmail> emails;
  List<TourobjectLink> links;
  String name;
  bool active;
  bool published;
  String description;
  String coordN;
  String coordE;
  String address;

  factory Tourobject.fromMap(Map<String, dynamic> json) => Tourobject(
    id: json["id"],
    category: List<Category>.from(json["category"].map((x) => Category.fromMap(x))),
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromMap(x))),
    phones: List<TourobjectPhone>.from(json["phones"].map((x) => TourobjectPhone.fromMap(x))),
    emails: List<TourobjectEmail>.from(json["emails"].map((x) => TourobjectEmail.fromMap(x))),
    links: List<TourobjectLink>.from(json["links"].map((x) => TourobjectLink.fromMap(x))),
    name: json["name"],
    active: json["active"] == 0 ? false : true,
    published: json["published"] == 0 ? false : true,
    description: json["description"],
    // coordN: json["coordN"] == null ? null : json["coordN"],
    // coordE: json["coordE"] == null ? null : json["coordE"],
    coordN: json["coordN"],
    coordE: json["coordE"],
    address: json["address"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "category": List<dynamic>.from(category.map((x) => x.toMap())),
    "photos": List<dynamic>.from(photos.map((x) => x.toMap())),
    "phones": List<dynamic>.from(phones.map((x) => x.toMap())),
    "emails": List<dynamic>.from(emails.map((x) => x.toMap())),
    "links": List<dynamic>.from(links.map((x) => x.toMap())),
    "name": name,
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
    "description": description,
    // "coordN": coordN == null ? null : coordN,
    // "coordE": coordE == null ? null : coordE,
    "coordN": coordN,
    "coordE": coordE,
    "address": address,
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.active,
    this.published,
  });

  int id;
  String name;
  bool active;
  bool published;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    active: json["active"] == 0 ? false : true,
    published: json["published"] == 0 ? false : true,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
  };
}

class TourobjectEmail {
  TourobjectEmail({
    this.id,
    this.email,
    this.tourobject,
  });

  int id;
  String email;
  int tourobject;

  factory TourobjectEmail.fromMap(Map<String, dynamic> json) => TourobjectEmail(
    id: json["id"],
    email: json["email"],
    tourobject: json["tourobject"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "tourobject": tourobject,
  };
}

class TourobjectLink {
  TourobjectLink({
    this.id,
    this.link,
    this.tourobject,
  });

  int id;
  String link;
  int tourobject;

  factory TourobjectLink.fromMap(Map<String, dynamic> json) => TourobjectLink(
    id: json["id"],
    link: json["link"],
    tourobject: json["tourobject"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "link": link,
    "tourobject": tourobject,
  };
}

class TourobjectPhone {
  TourobjectPhone({
    this.id,
    this.phone,
    this.tourobject,
  });

  int id;
  String phone;
  int tourobject;

  factory TourobjectPhone.fromMap(Map<String, dynamic> json) => TourobjectPhone(
    id: json["id"],
    phone: json["phone"],
    tourobject: json["tourobject"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "phone": phone,
    "tourobject": tourobject,
  };
}

class Photo {
  Photo({
    this.id,
    this.name,
    this.tourobject,
  });

  int id;
  String name;
  int tourobject;

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
    id: json["id"],
    name: json["name"],
    tourobject: json["tourobject"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "tourobject": tourobject,
  };
}

List<SubTourobject> subtourobjectFromMap(String str) => List<SubTourobject>.from(json.decode(str).map((x) => SubTourobject.fromMap(x)));

String subtourobjectToMap(List<SubTourobject> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

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
    coordN: json["coordN"] == null? json["coordn"] :json["coordN"],
    coordE: json["coordE"] == null? json["coorde"] :json["coordE"],
    address: json["address"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "active": active == false ? 0 : 1,
    "published": published == false ? 0 : 1,
    "description": description,
    // "coordN": coordN == null ? null : coordN,
    // "coordE": coordE == null ? null : coordE,
    "coordN": coordN,
    "coordE": coordE,
    "address": address,
  };
}


List<TourobjectToCategoryModel> tourobjectToCategoryModelFromMap(String str) => List<TourobjectToCategoryModel>.from(json.decode(str).map((x) => TourobjectToCategoryModel.fromMap(x)));

String tourobjectToCategoryModelToMap(List<TourobjectToCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));


class TourobjectToCategoryModel {
  TourobjectToCategoryModel({
    this.tourobject,
    this.category,
  });

  int tourobject;
  int category;

  factory TourobjectToCategoryModel.fromMap(Map<String, dynamic> json) => TourobjectToCategoryModel(
    tourobject: json["tourobject"],
    category: json["category"],
    );

  Map<String, dynamic> toMap() => {
    "tourobject": tourobject,
    "category": category,
  };
}