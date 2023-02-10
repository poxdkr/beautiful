import 'package:beautiful/config/Palette.dart';
import 'package:beautiful/screens/chat_screen.dart';
import 'package:beautiful/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

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
      home : AnimatedSplashScreen(
        curve: Curves.bounceIn,
        backgroundColor: Palette.googleColor,
        splash : Container(
          width : 150,
          height : 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 1,
              offset: Offset(1,3),
            )]
          ),
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 40.0,
              ),
              SizedBox(height:10),
              Text('WE CHAT LOVE',
                style : TextStyle(
                  color : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(
                    color: Colors.redAccent,
                    blurRadius: 2,
                    offset: Offset(0,1),
                  )]
                ),

              )
            ],
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: StreamBuilder(
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

      ),
    );
  }
}

