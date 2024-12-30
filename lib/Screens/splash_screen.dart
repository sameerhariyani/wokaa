import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wokaa/Screens/Wallet_Screen/wallet_connect_screen.dart';
import 'package:wokaa/common/colors.dart';
import 'package:wokaa/common/image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  /*void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WalletConnectScreen()),
      );
    });}*/
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SvgPicture.asset("$wokaalogo", )
        ,
      ),
    );
  }
}
