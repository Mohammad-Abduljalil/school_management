import 'package:flutter/cupertino.dart';

import 'MyColors.dart';

class MyConstantProperties{
  static const RoundedRectangleBorder shapeOfButton=RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)),);
  static const TextStyle textStyleUpOfTextField= TextStyle(fontSize: 15);
  static TextStyle get textStyleOfHintTextInTextField => TextStyle(color: MyColors.hintTextFieldInLoginPageColor, fontSize: 15);
}