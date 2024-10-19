import 'package:flutter/material.dart';
import 'package:fluttermysql2/screen/home.dart';
import 'package:fluttermysql2/screen/login.dart';
import 'package:fluttermysql2/screen/signup.dart';
import 'package:fluttermysql2/screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mysql',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/splash': (context) => const SplashScreenLoading(),
      },
    );
  }
}
