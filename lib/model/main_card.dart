import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/constant.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'MyInputField.dart';

class MainCard extends StatelessWidget {
  const MainCard({
    Key? key,
    required this.ItemName,
    required this.QntController,
    required this.PriceController,
  }) : super(key: key);

  final String ItemName;
  final TextEditingController QntController;
  final TextEditingController PriceController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: xCardBackgroundColor,
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ItemName,
              style:
                  TextStyle(color: xAppBarColor, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: MyInputField(
                  myController: QntController,
                  labelText: 'Quantity',
                  hintText: 'Enter quantity.',
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  inputFormate: [],
                ),
              ),
              Expanded(
                child: MyInputField(
                  myController: PriceController,
                  labelText: 'Price',
                  hintText: 'Enter price.',
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                  inputFormate: [],
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: xAppBarColor,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
