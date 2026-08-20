import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_management/Custom/MyColors.dart';

import 'MyConstantProperties.dart';

class MyCustomTextFieldWithLines extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final int maxLines;

  const MyCustomTextFieldWithLines({
    super.key,
    required this.textController,
    required this.hintText,
    int this.maxLines=1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
          const BorderSide(color: Color(0xFF1A3A6B), width: 1.5),
        ),
      ),
    );
  }
}
