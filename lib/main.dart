import 'package:beautiful/screens/chat_screen.dart';
import 'package:beautiful/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.redAccent
      ),
      home : StreamBuilder(
        //로그아웃이나 뒤로가기를 시도하여 이 페이지를 올 경우
        //FirebaseAuth.instance가 변화했는지를 체크하여 페이지를 이동시켜주기위해 StreamBuilder를 사용
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ChatScreen();
          }else{
            return LoginSignupScreen();
          }
        }
      ),
    );
  }
}

