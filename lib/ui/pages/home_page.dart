import 'package:flutter/material.dart';
import 'package:flutter_bloc_demo/data/bloc/base/bloc_provider.dart';
import 'package:flutter_bloc_demo/data/bloc/blocs/main_bloc.dart';
import 'package:flutter_bloc_demo/ui/pages/user_page.dart';

///主页
class HomePage extends StatelessWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(),
      ),
      body: Center(
        child: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserPage(title: '用户页面',))),
        child: Text('用户'),
      ),
    );
  }
}
