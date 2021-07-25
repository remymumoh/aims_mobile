import 'package:aims_mobile/exceptions/monitoring_exception.dart';
import 'package:aims_mobile/models/form_templates.dart';
import 'package:dio/dio.dart';

class FormTemplateService{

  final Dio _dio;

  FormTemplateService(this._dio);

  Future<List<FormTemplates>> getForms() async {
    try{
      final response = await _dio.get("http://10.0.2.2:8080/api/v1/form-templates");

      final results = List<Map<String, dynamic>>.from(response.data['results']);

      List<FormTemplates>formTemplates = results.map((formTemplateData) => FormTemplates.fromMap(formTemplateData)).toList(growable: false);
      return formTemplates;
    }on DioError catch(dioError){
      throw MonitoringException.fromDioError(dioError);

    }
  }
}