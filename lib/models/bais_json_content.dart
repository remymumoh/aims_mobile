import 'dart:convert';

BiaisvJsonContent biaisvJsonContentFromJson(String str) => BiaisvJsonContent.fromJson(json.decode(str));

String biaisvJsonContentToJson(BiaisvJsonContent data) => json.encode(data.toJson());

class BiaisvJsonContent {
  BiaisvJsonContent({
    this.id,
    this.basic,
    this.a,
    this.b,
    this.interviwer,
    this.c,
    this.d,
    this.e,
    this.f,
    this.g,
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy,
  });

  String id;
  String basic;
  String a;
  String b;
  String interviwer;
  String c;
  String d;
  String e;
  String f;
  String g;
  String dateCreated;
  String dateUpdated;
  String updatedBy;

  factory BiaisvJsonContent.fromJson(Map<String, dynamic> json) => BiaisvJsonContent(
    id: json["id"],
    basic: json["basic"],
    a: json["a"],
    b: json["b"],
    interviwer: json["interviwer"],
    c: json["c"],
    d: json["d"],
    e: json["e"],
    f: json["f"],
    g: json["g"],
    dateCreated: json["dateCreated"],
    dateUpdated: json["dateUpdated"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "basic": basic,
    "a": a,
    "b": b,
    "interviwer": interviwer,
    "c": c,
    "d": d,
    "e": e,
    "f": f,
    "g": g,
    "dateCreated": dateCreated,
    "dateUpdated": dateUpdated,
    "updatedBy": updatedBy,
  };
}
