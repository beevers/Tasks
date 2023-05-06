import 'package:flutter/material.dart';
import 'package:todo/model/details.dart';
import 'package:todo/screens.dart';
import 'package:todo/state.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path.getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  await Hive.initFlutter('hive_db');

  Hive.registerAdapter<Detail>(DetailAdapter());
  await Hive.openBox<Detail>('detail');
  await Hive.openBox('set');

  runApp( MaterialApp(
  debugShowCheckedModeBanner: false,
  home:ChangeNotifierProvider (
      create: (BuildContext context) { return AppProvider(); },
      child: const Todo()),));}