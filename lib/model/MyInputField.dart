import 'package:flutter/material.dart';

import '../components/constant.dart';

class MyInputField extends StatelessWidget {
  MyInputField(
      {required this.myController,
      required this.labelText,
      required this.hintText,
      required this.keyboardType,
      required this.inputFormate});

  final TextEditingController myController;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final List inputFormate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, bottom: 8, right: 5),
      child: TextFormField(
        controller: myController,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          // prefixIcon: IconButton(
          //     icon: Icon(Icons.remove),
          //     onPressed: () {
          //       // if (int.parse(myController.text) > 1) {
          //       //   myController.text =
          //       //       (int.parse(myController.text) - 1).toString();
          //       //}
          //     }),
          // suffixIcon: IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () {
          //       // myController.text =
          //       //     (int.parse(myController.text) + 1).toString();
          //     }),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: xAppBarColor),
          ),
          labelText: labelText,
          hintText: hintText,
          counterText: '',
          hintStyle: TextStyle(fontSize: 12),
          labelStyle: TextStyle(color: xAppBarColor),
        ),
      ),
    );
  }
}
