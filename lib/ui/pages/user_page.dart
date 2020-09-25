import 'package:flutter/material.dart';
import 'package:flutter_bloc_demo/data/bloc/base/bloc_provider.dart';
import 'package:flutter_bloc_demo/data/bloc/blocs/main_bloc.dart';
import 'package:flutter_bloc_demo/data/models/user_model.dart';

///用户页面
class UserPage extends StatelessWidget {
  final String title;

  const UserPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainBloc userBloc = BlocProvider.of<MainBloc>(context);
    userBloc.init();
    userBloc.inUserList.add('getUserList');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(),
      ),
      body: StreamBuilder(
          stream: userBloc.outUserList,
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            userBloc.outUserList.listen((userList)=>{});
            Future.delayed(Duration(seconds: 3));
            try{
              snapshot.data.length;
              return Column(
                children: snapshot.data
                    .map((user) => Text('${User().toJson(user: user)}',style: TextStyle(color: Colors.blue),))
                    .toList(),
              );
            }catch(e){
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  _body(BuildContext context) {
  }
}
