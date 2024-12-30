import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wokaa/Screens/Wallet_Screen/wallet_connect_screen.dart';
import 'package:wokaa/Screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Web3 Wallet Connect',
      debugShowCheckedModeBanner: false,



      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
    );
  }
}
