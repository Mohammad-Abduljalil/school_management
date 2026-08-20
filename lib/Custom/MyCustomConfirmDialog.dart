import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:school_management/Custom/MyColors.dart';

class MyCustomConfirmDialog {
  Future<bool> isConfermedDialog(BuildContext context, String bodyOfConfirm) async {
    bool result = false;

    await AwesomeDialog(
      context: context,
      width: MediaQuery.of(context).size.width>600?400:MediaQuery.of(context).size.width*0.85,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 20,vertical: 10),
      dialogBackgroundColor: Theme.of(context).cardColor,
      title: 'Confirm',
      titleTextStyle: TextStyle(color: MyColors.primaryText, fontWeight: FontWeight.bold, fontSize: 18),
      desc: bodyOfConfirm,
      descTextStyle: TextStyle(color: MyColors.primaryText.withOpacity(0.8)),
      buttonsTextStyle: const TextStyle(fontSize: 13,color: Colors.white),
      btnCancelOnPress: () {
        result = false;
      },
      btnOkOnPress: () {
        result = true;
      },
      btnOkText: "Save Changes",
      btnCancelText: "Cancel",
      btnOkColor: const Color(0xFF1C3486),
      onDismissCallback: (type) {
      },
    ).show();

    return result;
  }
}
