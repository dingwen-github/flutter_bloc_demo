import 'package:flutter/material.dart';
import 'package:flutter_bloc_demo/data/bloc/base/application_bloc.dart';
import 'package:flutter_bloc_demo/data/bloc/base/bloc_provider.dart';
import 'package:flutter_bloc_demo/data/bloc/blocs/main_bloc.dart';
import 'package:flutter_bloc_demo/ui/pages/home_page.dart';

Future<void> main() async {
  return runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
      child: BlocProvider<MainBloc>(
      bloc: MainBloc(),
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
