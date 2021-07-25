import 'dart:convert';
class FormTemplates{
  String id;
  String formName;
  String formSection;
  String formContents;
  FormTemplates({
    this.id,
    this.formName,
    this.formSection,
    this.formContents
});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'formName': formName,
      'formSection': formSection,
      'formContents': formContents
    };
  }

  factory FormTemplates.fromMap(Map<String,dynamic> map){
    if(map == null) return null;

    return FormTemplates(
      id: map['id'],
      formName: map['formName'],
      formSection: map['formSection'],
      formContents: map['formContents']
    );
  }


  String toJson()=> json.encode(toMap());

  factory FormTemplates.fromJson(String source) => FormTemplates.fromMap(jsonDecode(source));
}