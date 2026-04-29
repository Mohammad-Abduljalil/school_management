import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomLoadingButton extends StatelessWidget{
  final void Function()? onPressed;
  Color backgroundColorLeft;
  Color backgroundColorRight;
  Color foregroundColor;
  MyCustomLoadingButton({super.key,this.onPressed,required this.backgroundColorLeft,required this.backgroundColorRight,required this.foregroundColor});

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
          child:  Center(child: CircularProgressIndicator(color: this.foregroundColor,)),
      ),
    ));

  }

}