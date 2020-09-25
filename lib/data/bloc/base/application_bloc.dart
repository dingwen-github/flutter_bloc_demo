import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc_demo/common/config/appConfig.dart';
import 'package:flutter_bloc_demo/data/models/user_model.dart';
import 'package:flutter_bloc_demo/data/bloc/base/bloc_provider.dart';
import 'package:flutter_bloc_demo/utils/http_util.dart';

class ApplicationBloc implements BlocBase {
int appIndex = AppConfig.APP_INDEX;
  ///
  /// 广播流控制器初始化  int  stream
  ///
  StreamController<int> _streamController =
      StreamController<int>.broadcast();

  Stream<int> get outIndex => _streamController.stream;

  ///
  ///广播流控制器初始化 int sink
  ///
  StreamController<int> _sinkController =
      StreamController<int>.broadcast();

  StreamSink get inIndex => _sinkController.sink;

  ///构造器设置监听、
  ApplicationBloc() {
    _sinkController.stream.listen((_) {
      _streamController.sink.add(appIndex);
    });
  }

  ///释放资源
  void dispose() {
    _streamController.close();
    _sinkController.close();
  }

  @override
  void init() {
    // TODO: implement init
  }
}
