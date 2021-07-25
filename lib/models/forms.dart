import 'dart:convert';

FormsModel formsModelFromJson(String str) => FormsModel.fromJson(json.decode(str));

String formsModelToJson(FormsModel data) => json.encode(data.toJson());

class FormsModel {
  FormsModel({
    this.id,
    this.formName,
    this.dataContent,
    this.formSections,
    this.dateCreated,
    this.dateUpdated,
    this.userLocation,
    this.imeI,
    this.updatedBy,
    this.capturedBy,
  });

  String id;
  String formName;
  String dataContent;
  String formSections;
  DateTime dateCreated;
  DateTime dateUpdated;
  String userLocation;
  String imeI;
  String updatedBy;
  String capturedBy;

  factory FormsModel.fromJson(Map<String, dynamic> json) => FormsModel(
    id: json["id"],
    formName: json["formName"],
    dataContent: json["dataContent"],
    formSections: json["formSections"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    dateUpdated: DateTime.parse(json["dateUpdated"]),
    userLocation: json["userLocation"],
    imeI: json["imeI"],
    updatedBy: json["updatedBy"],
    capturedBy: json["capturedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "formName": formName,
    "dataContent": dataContent,
    "formSections" : formSections,
    "dateCreated": dateCreated.toIso8601String(),
    "dateUpdated": dateUpdated.toIso8601String(),
    "userLocation": userLocation,
    "imeI": imeI,
    "updatedBy": updatedBy,
    "capturedBy": capturedBy,
  };
}
