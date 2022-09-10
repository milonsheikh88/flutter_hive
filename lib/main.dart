import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hive/view/student_screen.dart';
import 'package:flutter_hive/view/teacher_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_hive/view/home_screen.dart';
import 'models/student_model.dart';
import 'models/teacher_model.dart';
import 'models/bank_model.dart';
import 'view/bank_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const secureStorage=FlutterSecureStorage();
  final encryptionKey=await secureStorage.read(key: 'hiveKey');
  if(encryptionKey==null){
    final key= Hive.generateSecureKey();
    secureStorage.write(key: 'hiveKey', value: base64Url.encode(key));
  }
  final key= base64Url.decode(encryptionKey.toString());


  ///   await Hive.deleteFromDisk();
  ///   Directory directory = await pathProvide.getApplicationDocumentsDirectory();
  ///   Hive.init(directory.path);

  await Hive.initFlutter('hive_demo');
  await Hive.openBox('home_box');

  Hive.registerAdapter<StudentModel>(StudentModelAdapter());
  Hive.registerAdapter<TeacherModel>(TeacherModelAdapter());
  Hive.registerAdapter<BankModel>(BankModelAdapter());

  await Hive.openBox<StudentModel>('student_box');
  await Hive.openBox<TeacherModel>('teacher_box');
  await Hive.openBox<BankModel>('bank_box', encryptionCipher: HiveAesCipher(key));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hive',
      theme: ThemeData(
        primaryColor: const Color(0xff2F8D46),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final pages = [
    const HomeScreen(),
    const StudentScreen(),
    const TeacherScreen(),
    const BankScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: buildNavBar(context),
    );
  }

  Container buildNavBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: Colors.white,
              size: 28,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.school,
              color: Colors.white,
              size: 28,
            )
                : const Icon(
              Icons.school_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
              Icons.person,
              color: Colors.white,
              size: 28,
            )
                : const Icon(
              Icons.person_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            icon: pageIndex == 3
                ? const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 28,
            )
                : const Icon(
              Icons.monetization_on_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

}
