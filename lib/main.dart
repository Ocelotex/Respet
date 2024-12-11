import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_projetinho/firebase_options.dart';
import 'package:flutter_projetinho/view/aboutView.dart';
import 'package:flutter_projetinho/view/loginView.dart';
import 'package:flutter_projetinho/view/registerView.dart';
import 'package:flutter_projetinho/view/reportView.dart';
import 'report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final reportManager = ReportManager();

  runApp(
    DevicePreview(
      builder: (context) => MyApp(reportManager: reportManager),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ReportManager reportManager;

  MyApp({required this.reportManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RESPET',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/report': (context) => ReportView( reportManager: reportManager),
        '/about': (context) => AboutView(),
      },
    );
  }
}
