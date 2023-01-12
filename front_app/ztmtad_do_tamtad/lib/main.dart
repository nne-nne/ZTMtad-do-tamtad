import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ztmtad_do_tamtad/home_page.dart';
import 'package:ztmtad_do_tamtad/ztm_repository.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('ZTMtad o tutaj');
    setWindowMaxSize(const Size(600, 1080));
    setWindowMinSize(const Size(300, 650));
  }
  final ztmRepo = ZTMRepository();
  ztmRepo.getStops();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ztmRepo,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
