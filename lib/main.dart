import 'package:beautiful/config/Palette.dart';
import 'package:beautiful/screens/chat_screen.dart';
import 'package:beautiful/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_admin/firebase_admin.dart';

//백그라운드 활성화
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  //FlutterBinding 초기화
  WidgetsFlutterBinding.ensureInitialized();
  //FireBase초기화
  await Firebase.initializeApp();
  //해당 기기의 토근 발급 및 확인
  var fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BOUPZvpCO-wJSCMrBw4upvnPQfeY4VXbmXzSFpQdQ9wKJZGIx0c2iVCw4TdGWeVgCANTjGfhYs4KMMHO_UrXypg");
  //FirebaseMessaging Background 메시지 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //기존 토큰 삭제시 재발급
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {});
  //안드로이드 채널 설정
  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );
  //flutterLocalNotificationsPlugin 과 channel 설정 결합
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //앱시작
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
      //애니메이티드 스플래시
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

