import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/Auth/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  sign_in(),
      routes: {
        "sign_in": (context)=> sign_in(),
      },
    );
  }
}

