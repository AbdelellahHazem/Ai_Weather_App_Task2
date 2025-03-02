import 'package:dio/dio.dart';

import 'endpoints.dart';








class DioHelper{
  static Dio ? dio;
  static void init(){
    dio= Dio(BaseOptions(
        baseUrl:
        Endpoints.BaseURL,
        receiveDataWhenStatusError: true,
        headers: {
          'Postman-Token':'<calculated when request is sent>',
          'Host':'<calculated when request is sent>',
          'User-Agent':'PostmanRuntime/7.42.0',
          'Accept':'*/*',
          'Accept-Encoding':'gzip, deflate, br',
          'Connection':'keep-alive',
          'Accept':'application/json',
          'Content-Type':'application/json'
        }
    ));
  }
  static Future <Response> get({required String endpoint,Map<String,dynamic> ?body ,Map<String,dynamic> ?params,String ?token}) async {
    try{

      dio?.options.headers={
        "Authorization": "Bearer $token",
      };
      Response? response  = await dio ?.get(endpoint,data:body ,queryParameters:params  );
      return response!;
    }catch(e){
      rethrow;
    }

  }


  static Future <Response> put({required String endpoint,String ?token,Map<String,dynamic> ?body ,FormData ? formdata ,Map<String,dynamic> ?params}) async {
    try{
      dio?.options.headers={
        "Authorization":"Bearer $token",
      };
      Response? response  = await dio ?.put(endpoint,data:body??formdata ,queryParameters:params  );
      return response!;
    }catch(e){
      rethrow;
    }

  }


  static Future <Response> post({required String endpoint,String ?token,Map<String,dynamic> ?body,FormData ? formdata ,Map<String,dynamic> ?params}) async {
    try{
      dio?.options.headers={
        "Authorization": "Bearer $token",
      };
      Response? response  = await dio ?.post(endpoint,data:body??formdata ,queryParameters:params  );
      return response!;
    }catch(e){
      rethrow;
    }

  }


  static Future <Response> delete({required String endpoint,Map<String,dynamic> ?body ,Map<String,dynamic> ?params,String ?token}) async {
    try{

      dio?.options.headers={
        "Authorization": "Bearer $token",
      };
      Response? response  = await dio ?.delete(endpoint,data:body ,queryParameters:params  );
      return response!;
    }catch(e){
      rethrow;
    }

  }



}