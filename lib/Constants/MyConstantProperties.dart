import 'package:flutter/cupertino.dart';

import 'MyColors.dart';

class MyConstantProperties{
  static const RoundedRectangleBorder shapeOfButton=RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)),);
  static const TextStyle textStyleUpOfTextField= TextStyle(fontSize: 15, color:MyColors.textUpOfTextFieldInSignUp,);
  static const TextStyle textStyleOfHintTextInTextField= TextStyle(color: MyColors.hintTextFieldInLoginPageColor,fontSize: 15);
}