import 'dart:convert';

BasicInfoModel basicInfoModelFromJson(String str) => BasicInfoModel.fromJson(json.decode(str));

String basicInfoModelToJson(BasicInfoModel data) => json.encode(data.toJson());

class BasicInfoModel {
  BasicInfoModel({
    this.id,
    this.monitorName,
    this.monitorPhoneno,
    this.fieldleadEmpno,
    this.fieldleadName,
    this.fieldleadPhone,
    this.fieldteamId,
    this.ea,
    this.district,
    this.region,
    this.date,
    this.timeStarted,
    this.timeEnded,
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy,
  });

  String id;
  String monitorName;
  String monitorPhoneno;
  String fieldleadEmpno;
  String fieldleadName;
  String fieldleadPhone;
  String fieldteamId;
  String ea;
  String district;
  String region;
  DateTime date;
  DateTime timeStarted;
  String timeEnded;
  DateTime dateCreated;
  DateTime dateUpdated;
  String updatedBy;

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) => BasicInfoModel(
    id: json["id"],
    monitorName: json["monitorName"],
    monitorPhoneno: json["monitorPhoneno"],
    fieldleadEmpno: json["fieldleadEmpno"],
    fieldleadName: json["fieldleadName"],
    fieldleadPhone: json["fieldleadPhone"],
    fieldteamId: json["fieldteamId"],
    ea: json["ea"],
    district: json["district"],
    region: json["region"],
    date: DateTime.parse(json["date"]),
    timeStarted: DateTime.parse(json["timeStarted"]),
    timeEnded: json["timeEnded"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    dateUpdated: DateTime.parse(json["dateUpdated"]),
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "monitorName": monitorName,
    "monitorPhoneno": monitorPhoneno,
    "fieldleadEmpno": fieldleadEmpno,
    "fieldleadName": fieldleadName,
    "fieldleadPhone": fieldleadPhone,
    "fieldteamId": fieldteamId,
    "ea": ea,
    "district": district,
    "region": region,
    "date": date.toIso8601String(),
    "timeStarted": timeStarted.toIso8601String(),
    "timeEnded": timeEnded,
    "dateCreated": dateCreated.toIso8601String(),
    "dateUpdated": dateUpdated.toIso8601String(),
    "updatedBy": updatedBy,
  };
}
