import 'dart:async';
import 'dart:collection';
import 'package:flutter_bloc_demo/common/config/appConfig.dart';
import 'package:flutter_bloc_demo/data/api/api.dart';
import 'package:flutter_bloc_demo/data/models/result_model.dart';
import 'package:flutter_bloc_demo/data/models/user_model.dart';
import 'package:flutter_bloc_demo/data/bloc/base/bloc_provider.dart';
import 'package:flutter_bloc_demo/utils/http_util.dart';

class MainBloc implements BlocBase {
  ///用户列表
  List<User> _userList;

  ///
  /// 广播流控制器初始化  int  stream
  ///
  StreamController<List<User>> _streamController =
      StreamController<List<User>>.broadcast();

  Stream<List<User>> get outUserList => _streamController.stream;

  ///
  ///广播流控制器初始化 User sink
  ///
  StreamController<String> _sinkController =
      StreamController<String>.broadcast();

  StreamSink get inUserList => _sinkController.sink;

  void fetch() async {
    ResultModel resultModel =
        await HttpUtil.request(Api.GET_USER_LIST, method: HttpUtil.GET);
    List users = resultModel.data;
    _userList = users.map((user) => User.fromJson(user)).toList();
  }

  ///释放资源
  void dispose() {
    _streamController.close();
    _sinkController.close();
  }

  ///设置监听、请求数据
  @override
  void init() {
    _sinkController.stream.listen((event) {
      //TODO 根据事件处理数据
      print(event);
      fetch();
      _streamController.sink.add(UnmodifiableListView<User>(_userList));
    });
  }
}
