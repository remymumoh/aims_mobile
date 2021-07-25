import 'dart:convert';

InterviewerModel interviewerModelFromJson(String str) => InterviewerModel.fromJson(json.decode(str));

String interviewerModelToJson(InterviewerModel data) => json.encode(data.toJson());

class InterviewerModel {
  InterviewerModel({
    this.id,
    this.interviewerNo,
    this.interviwerName,
    this.interviwerPhone,
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy,
  });

  String id;
  String interviewerNo;
  String interviwerName;
  String interviwerPhone;
  DateTime dateCreated;
  DateTime dateUpdated;
  String updatedBy;

  factory InterviewerModel.fromJson(Map<String, dynamic> json) => InterviewerModel(
    id: json["id"],
    interviewerNo: json["interviewerNo"],
    interviwerName: json["interviwerName"],
    interviwerPhone: json["interviwerPhone"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    dateUpdated: DateTime.parse(json["dateUpdated"]),
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "interviewerNo": interviewerNo,
    "interviwerName": interviwerName,
    "interviwerPhone": interviwerPhone,
    "dateCreated": dateCreated.toIso8601String(),
    "dateUpdated": dateUpdated.toIso8601String(),
    "updatedBy": updatedBy,
  };
}
