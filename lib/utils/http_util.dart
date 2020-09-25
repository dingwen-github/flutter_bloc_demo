import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_bloc_demo/data/api/api.dart';
import 'package:flutter_bloc_demo/data/models/result_model.dart';


class HttpUtil {
  // 实例
  static HttpUtil instance;

  /// http 请求方法
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String PATCH = 'PATCH';
  static const String DELETE = 'DELETE';


  Dio dio;
  BaseOptions options;
  CancelToken cancelToken = CancelToken();

  static HttpUtil getInstance() {
    if (null == instance) {
      instance = HttpUtil();
    }
    return instance;
  }

  HttpUtil() {
    _internal();
  }

  _internal() async {
    /// BaseOptions、Options、RequestOptions
    /// 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      // 请求基地址
        baseUrl: Api.BASE_URL,
        connectTimeout: 10000,
        receiveTimeout: 30000,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "X-Client-Type": "mApproval"
        });

    dio = Dio(options);
    dio.interceptors.add(LogInterceptor(responseBody: true)); //开启请求日志
  }

  static Future<ResultModel> request(String uri,
      {data, method, contentType, queryParams, headers}) async {
    /// 请求参数处理
    data = data ?? {};
    method = method ?? "GET";
    contentType = contentType ?? Headers.jsonContentType;
    queryParams = queryParams ?? {};
    queryParams.forEach((key, value) {
      if (uri.indexOf(key) != -1) {
        uri = uri.replaceAll(':$key', value.toString());
      }
    });
    String url = uri;

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    developer.log("Http请求地址：", name: "http", error: "$method $url");
    developer.log('Http请求参数：', name: 'http', error: data.toString());
    Response response;
    ResultModel result;
    try {
      Options options = Options(method: method, contentType: contentType);
      if (headers != null) {
        options.headers = headers;
      }
      response =
      await getInstance().dio.request(url, data: data, options: options);

      result = ResultModel.fromJson(response.data);
    } on DioError catch (error) {
//      Global.navigatorKey.currentState.pop();
      developer.log('Http请求出错：',
          name: 'http', error: error?.response?.data?.toJson()?.toString());
      result = error?.response?.data ??
          ResultModel(code: 500, message: "系统异常，请稍后重试！");
    }
    return result;
  }

  errorHandler(DioError error) {
    ResultModel result;
    if (error.response.data != null) {
      result = ResultModel.toModel(error.response.data);
      if (result.code == 200) {
        result.code = error.response.statusCode;
      }
    } else {
      result = ResultModel(code: 500, data: {});
      error.response = Response(statusCode: 500);
    }

    if (error.type == DioErrorType.CONNECT_TIMEOUT) {
      result.message = "链接超时！";
    }
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        result.message = "连接超时！";
        break;
      case DioErrorType.SEND_TIMEOUT:
        result.message = "请求超时！";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        result.message = "响应超时！";
        break;
      case DioErrorType.CANCEL:
        result.message = "请求取消！";
        break;
      case DioErrorType.RESPONSE:
        result.message = error.response.data["message"] ?? "请求异常，请联系管理员！";
        break;
      default:
        result.message = "未知错误！";
        break;
    }
    error.response.data = result;
    return error;
  }
}
