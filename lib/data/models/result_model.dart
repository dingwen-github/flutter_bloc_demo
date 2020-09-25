import 'dart:convert' as convert;
import 'package:dio/dio.dart';

///Http返回结果模型
class ResultModel {
  int code = 200;
  String message = "Ok!";
  dynamic data;
  String path;
  var currentTime;

  ResultModel(
      {this.code, this.message, this.data, this.path, this.currentTime});

  isSuccess() {
    return code == 200;
  }

  static toModel(Response response) {
    dynamic result = response.data;
    if (isNotResultModel(result)) {
      return ResultModel(
        code: response.statusCode,
        message: response.statusMessage,
        data: result ?? {},
        path: null,
        currentTime: null,
      );
    } else {
      return ResultModel(
        code: result["code"] ?? response.statusCode,
        message: result["message"] ?? response.statusMessage,
        data: result["data"] ?? {},
        path: result["path"] ?? null,
        currentTime: result["currentTime"] ?? null,
      );
    }
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      code: json["code"],
      message: json["message"],
      data: json["data"],
      path: json["path"],
      currentTime: json["currentTime"],
    );
  }

  ///判断是否是ResultModel
  static isNotResultModel(dynamic result) {
    bool flag = false;
    if (result is Map) {
      flag = (result['code'] == null && result['message'] == null);
    } else if (result is List) {
      flag = true;
    } else {
      flag = false;
    }
    return flag;
  }

  ///Dart model 转 json
  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "path": path,
      "currentTime": currentTime,
      "data": data
    };
  }
}
