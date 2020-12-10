
import 'package:basic_chat_app/screens/authScreen.dart';
import 'package:basic_chat_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx, userSnapshot) {
        if(userSnapshot.hasData){
          return ChatScreen();
        }
        return AuthScreen();
//
//      AuthScreen(),
//      routes: {
//        ChatScreen.routeName: (context) => ChatScreen(),

      })
    );
  }
  }


