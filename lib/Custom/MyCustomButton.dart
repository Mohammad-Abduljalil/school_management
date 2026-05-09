import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget{
  final void Function()? onPressed;
  String title;
  Color backgroundColorLeft;
  Color backgroundColorRight;
  Color foregroundColor;
  double textSize;
  MyCustomButton({super.key,this.onPressed,required this.title,required this.backgroundColorLeft,required this.backgroundColorRight,required this.foregroundColor,this.textSize=16});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            this.backgroundColorLeft,
            this.backgroundColorRight,
          ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: this.onPressed,
          child: Text(this.title, style: TextStyle(color: this.foregroundColor,fontWeight: FontWeight.bold,fontSize: this.textSize)),
        ),
      ),
    );

  }

}