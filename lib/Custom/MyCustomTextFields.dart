import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_management/Custom/MyColors.dart';

import 'MyConstantProperties.dart';

class MyCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextInputAction textInputAction;

  const MyCustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType=TextInputType.text,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      textInputAction: textInputAction,
      onChanged: onChanged,
      readOnly: readOnly,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Theme.of(context).cardColor,
        filled: true,
        hintText: hintText,
        hintStyle: MyConstantProperties.textStyleOfHintTextInTextField,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword ?
        IconButton(icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: MyColors.iconInAuthTextFieldColor,),
          onPressed: onSuffixIconPressed,
          focusNode: FocusNode(skipTraversal: true),
        )
            : suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColors.borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
