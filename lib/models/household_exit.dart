import 'dart:convert';

HouseHoldExit houseHoldExitFromJson(String str) => HouseHoldExit.fromJson(json.decode(str));

String houseHoldExitToJson(HouseHoldExit data) => json.encode(data.toJson());

class HouseHoldExit {
  HouseHoldExit({
    this.id,
    this.question,
    this.answer,
    this.observations,
    this.comments,
    this.dateCreated,
    this.dateUpdated,
    this.updatedBy,
  });

  String id;
  String question;
  String answer;
  String observations;
  String comments;
  DateTime dateCreated;
  DateTime dateUpdated;
  String updatedBy;

  factory HouseHoldExit.fromJson(Map<String, dynamic> json) => HouseHoldExit(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
    observations: json["observations"],
    comments: json["comments"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    dateUpdated: DateTime.parse(json["dateUpdated"]),
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
    "observations": observations,
    "comments": comments,
    "dateCreated": dateCreated.toIso8601String(),
    "dateUpdated": dateUpdated.toIso8601String(),
    "updatedBy": updatedBy,
  };
}
